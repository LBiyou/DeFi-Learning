// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {UserKeeper, Airdrop} from "../src/Automation.sol";

contract DeployAutomation is Script {
    function run() external returns (UserKeeper userKeeper, Airdrop airdrop) {
        vm.startBroadcast();
        userKeeper = new UserKeeper();
        airdrop = userKeeper.airdrop();
        vm.stopBroadcast();
    }
}
