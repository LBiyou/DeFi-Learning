// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DataFeed.sol";

contract DeployDataFeed is Script {
    function run() external returns(PriceFeed priceFeed) {
        vm.startBroadcast();
        priceFeed = new PriceFeed();
        vm.stopBroadcast();
    }
}