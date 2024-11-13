// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AToken is Ownable, ERC20 {
    constructor() Ownable(msg.sender) ERC20("AToken", "AT") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}