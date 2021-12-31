// SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;
pragma solidity ^0.8.0;

import './CloneFactory.sol';
import './Match.sol';
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../node_modules/@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


contract Factory is CloneFactory {
    using SafeERC20 for IERC20;
    address masterContract;
    event MatchCreated(address newThingAddress);

    constructor(address _masterContract){
        masterContract = _masterContract;
    }


    function createChild(address payable _player1,
                address payable _player2,
                uint256 _player1Choice,
                uint256 _player2Choice,
                uint256 _wager) external returns(address){
        address payable matchContract = createClone(masterContract);

        // LINK address on MUMBAI
        IERC20 tokenLINK = IERC20(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        tokenLINK.safeTransfer(matchContract, 0.1 * 10 ** 18);

        Match(matchContract).init(address(this), _player1, _player2, _player1Choice, _player2Choice, _wager);
        emit MatchCreated(matchContract);
        return matchContract;
    }

    
    function getBalanceOfToken(address tokenAddress) public view returns (uint){
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    fallback () external payable{
        // custom function code
    }


    receive() external payable {
        // custom function code
    }
}