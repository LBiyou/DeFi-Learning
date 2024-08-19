// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// contract address: 0x9AC6521008b6Cf909b0360db0B6819bBa895D559 on sepolia chain
contract PriceFeed {
    AggregatorV3Interface priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    function getPrice() public view returns (int256 price) {
        (, price, , , ) = priceFeed.latestRoundData();
    }
}
