// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IVRFCoordinatorV2Plus, VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

// contract address : 0xD12546C3f4777fe85Cbb9101e4FC3a8e2D0D84fD
contract ChainlinkVRF is VRFConsumerBaseV2Plus {

    IVRFCoordinatorV2Plus COORDINATOR;
    address vrfCoordinatorAddr = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    uint256[] public s_randomWords;

    constructor() VRFConsumerBaseV2Plus(vrfCoordinatorAddr) {
        COORDINATOR = IVRFCoordinatorV2Plus(vrfCoordinatorAddr);
    }

    function requestRandomWrods(
        bytes32 keyHash,
        uint256 subId,
        uint16 requestConfirmations,
        uint32 callbackGasLimit,
        uint32 numWords
    ) external onlyOwnerOrCoordinator returns (uint256 requestId) {
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest(
                keyHash,
                subId,
                requestConfirmations,
                callbackGasLimit,
                numWords,
                ""
            );
        requestId = COORDINATOR.requestRandomWords(request);
    }

    function fulfillRandomWords(
        uint256,
        uint256[] calldata randomWords
    ) internal override {
        s_randomWords = randomWords;
    }

    function getRandomWrods() external view returns (uint256[] memory) {
        return s_randomWords;
    }
}
