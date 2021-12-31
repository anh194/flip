from brownie import accounts, network, Match, config, Factory


def deployMatch():
    account = get_account()
    match = Match.deploy({"from": account})
    print(match)
    
    factory = Factory.deploy(match, {"from": account})

    print(factory)


    factory = Factory.at("0x4A0C4d87CBd9C0121AA26E856cfad69C6d53e031")
    tmp = factory.createChild(
        "0xFF2dc3AB25C48dCCdfAe9f53fA5Fb7B70e362925",
        "0x8dE3622e888D6d03966A3C395051C23CaC45A1d9",
        0,
        1,
        2,
        {"from": account})
    print(tmp.events)



def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deployMatch()
