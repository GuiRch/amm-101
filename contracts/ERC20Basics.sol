pragma solidity >=0.6.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Basics is ERC20 {

    address public owner;

	constructor(string memory name, string memory symbol, uint256 initialSupply) public ERC20(name, symbol) 
	{
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }
}