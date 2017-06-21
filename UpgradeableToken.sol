// Example upgradable Token contract

import "ERC20.sol";

contract UpgradableToken is Upgradable, ERC20Interface
{

    string constant VERSION = "UpgradableToken 0.1.0-alpha";

    event UpgradedTokens(address indexed _successor,
        address indexed _holder, uint _amount);
    
    function upgradeTokens() public isUpgraded returns (uint)
    {
        uint tokens = balanceOf[msg.sender];
        if (tokens == 0) throw;
        delete balanceOf[msg.sender];
        totalSupply -= tokens;
        if(!UpgradableToken(successor).upgradeTokensFor(msg.sender, tokens))
            throw;
        return tokens;
    }

    function upgradeTokensFor (address holder, uint tokens)
        external returns (bool)
    {
        if (msg.sender != predecessor) throw;
        balanceOf[holder] += tokens;
        totalSupply += tokens;
        return true;
    }
    
}