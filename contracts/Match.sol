// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


contract Match is VRFConsumerBase{
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    string public name;
    address owner;
    address payable public player1;
    address payable public player2;
    address payable public winner;

    uint256 public player1Choice; 
    uint256 public player2Choice;
    uint256 public wager;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    event randomReturn(bytes32 requestId, uint256 randomness);
    event TransferSent(address destAddr, uint256 amount);
    event finalWinner(address winner, uint256 randomResult);
    event test(uint256 tok);


    uint256 public portion;
    uint256 public winnerPortion;

    function getPortion() public view  returns (uint256){
        return portion;
    }

    function getWinnerPortion() public view  returns (uint256){
        return portion;
    }


    mapping(address => uint256) public balances;

    //first cordinator
    //second link address
    constructor() VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, 
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        )
    {
        name = "master";
    }



    function getPlayer1() public view returns (address){
        return player1;
    }


    function getPlayer2() public view returns (address){
        return player2;
    }


    function getPlayer1Choice() public view returns (uint256){
        return player1Choice;
    }


    function getPlayer2Choice() public view returns (uint256){
        return player2Choice;
    }


    function getWinner() public view returns (address){
        return winner;
    }


    function getRandomResult() public view returns(uint256){
        return randomResult;
    }


    function setWinner() external{
        require(player1 != address(0), "has not init");

        getRandomNumber();

        uint256 result = randomResult % 2;

        if (result == player1Choice){
            winner = player1;
        }else{
            winner = player2;
        }
    }


    function payWinner() external {
        require(winner != address(0), "has not setWinner");

        address maticAddress = 0x0000000000000000000000000000000000001010;
        uint256 maticBalance = IERC20(maticAddress).balanceOf(address(this));

        require(maticBalance != 0, "0 matic");

        // portion  = maticBalance.div(uint256(10));
        // winnerPortion = maticBalance / 10 * 9;

        IERC20(maticAddress).safeTransfer(winner, maticBalance);
        // IERC20(maticAddress).safeTransfer(master, IERC20(maticAddress).balanceOf(address(this)));
        emit test(maticBalance);
        emit test(winnerPortion);

    }

    /** 
     * Requests randomness 
     */
    function getRandomNumber() internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        emit randomReturn(requestId, randomness);
        randomResult = randomness;
    }


    /** 
     * Withdraw leftover LINK after random
     */
    function withdrawRemainLINK() public{
        address linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
        uint256 erc20balance = IERC20(linkAddress).balanceOf(address(this));

        IERC20(linkAddress).safeTransfer(payable(owner), erc20balance);
        emit TransferSent(owner, erc20balance);
    }


    function getBalanceOfToken(address tokenAddress) public view returns (uint){
        return IERC20(tokenAddress).balanceOf(address(this));
    }
    

    function init(address _owner, address payable _player1, address payable _player2, uint256 _player1Choice, uint256 _player2Choice, uint256 _wager) external {
        // require(bytes(name).length == 0, "Already init"); // ensure not init'd already.
        name = "clone";
        owner = _owner;
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK. Depend on network
        player1 = _player1;
        player2 = _player2;
        player1Choice = _player1Choice;
        player2Choice = _player2Choice;
        wager = _wager;
    }


    fallback () external payable{
        // custom function code
    }


    receive() external payable {
        // custom function code
    }
}