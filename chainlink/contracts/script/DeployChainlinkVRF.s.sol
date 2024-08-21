// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ChainlinkVRF} from "../src/ChainlinkVRF.sol";

contract DeployChainlinkVRF is Script {
    function run() external returns(ChainlinkVRF chainlinkVRF) {
        vm.startBroadcast();
        chainlinkVRF = new ChainlinkVRF();
        vm.stopBroadcast();
    }
}