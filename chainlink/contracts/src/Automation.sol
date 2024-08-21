// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

// contract address => 0x48a8423d88d492B929dDD60D36BdC112366Ae52e
contract UserKeeper is AutomationCompatibleInterface {
    Airdrop public airdrop;

    constructor() {
        airdrop = new Airdrop();
    }

    function checkUpkeep(
        bytes calldata
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        if (airdrop.winner() == address(this)) {
            return (true, "");
        }
    }

    function performUpkeep(bytes calldata) external override {
        airdrop.airdrop();
    }
}

// contract address => 0xaCCd83C73663Ef519501a38FA0C26d1736b1CB5c
contract Airdrop {
    mapping(address => uint256) public rewards;
    address public owner;
    address public winner;

    constructor() {
        owner = tx.origin; // there is a risk
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setWinner(address _winner) external onlyOwner {
        winner = _winner;
    }

    function airdrop() external {
        require(msg.sender == winner, "You are not the winner.");
        rewards[msg.sender] = 100;
    }
}
