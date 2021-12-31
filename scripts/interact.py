from brownie import accounts, network, Match, config


#brownie console --network {network_name}
def interact_contract():
    account = get_account()
    print(Match[-1])

    match = Match[-1]
    match.setMatch(
        "0x09C1Bb6481f957cab5513a2529340D666791B95a",
        "0xFF2dc3AB25C48dCCdfAe9f53fA5Fb7B70e362925",
        0,
        1,
        1,
        {"from": account}
    )
    print(match.getPlayer1())


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    interact_contract()