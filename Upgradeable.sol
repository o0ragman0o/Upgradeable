/*
file: Upgradable.sol
ver:    0.1.0-alpha
updated:9-Sep-2016
author: Darryl Morris
email:  o0ragman0o AT gmail.com

An Ethereum Solidity contract to provide upgrade ability to inheriting
contracts. 

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU lesser General Public License for more details.
<http://www.gnu.org/licenses/>.
*/


pragma solidity ^0.4.0;

import "Base.sol";

contract Upgradable is Owned
{
/* Constants */

    string constant "Upgradeable 0.1.0-alpha";

/* State Variables */

    address public predecessor;
    address public successor;

/* Events */

    event Upgraded(address indexed _successor);
    event UpgradedFrom(address indexed _predecessor);

/* Modifiers */

    // Can be used to allow operation of functions post upgrade 
    modifier isUpgraded() {
        if (successor == 0x0) throw;
        _;
    }
    
    // Can be used to disallow functions post upgrade.
    modifier notUpgraded() {
        if (successor != 0x0) throw;
        _;
    }
    
    modifier hasPredecessor() {
        if (predecessor == 0x0) throw;
        _;
    }

/* Functions */    
    // Can only be called 'once' from the potential 'successor' contract
    // by the 'owner' of the predesessor (this) contract.
    function upgrade() external notUpgraded returns (bool)
    {
        if (tx.origin != owner || tx.origin == msg.sender) throw;
        successor = msg.sender;
        Upgraded(successor);
        return true;
    }
    
    // To be called from the successor to initiate upgrade from the predecessor
    function upgradeFrom(address _predecessor)
        public notUpgraded returns (bool)
    {
        predecessor = _predecessor;
        if(!Upgradable(_predecessor).upgrade()) throw;
        return true;
    }
}