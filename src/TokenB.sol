// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenB is ERC20, Ownable {
    constructor() ERC20("TokenB", "TKNB") Ownable(msg.sender) {
        _mint(msg.sender, 1000_000_000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
