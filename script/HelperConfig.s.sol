// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {EnglishAuction} from "../src/EnglishAuction.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address nftAddress;
        uint256 nftId;
        uint256 highestBid;
    }

    NetworkConfig public networkConfig;

    constructor() {
        networkConfig = NetworkConfig({
            nftAddress: 0x4E1f41613c9084FdB9E34E11fAE9412427480e56,
            nftId: 4007,
            highestBid: 717900000000000000
        });
    }

    function getConfigVariables() public view returns (address, uint256, uint256) {
        return (networkConfig.nftAddress, networkConfig.nftId, networkConfig.highestBid);
    }
}
