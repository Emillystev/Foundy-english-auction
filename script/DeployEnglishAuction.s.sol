// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {EnglishAuction} from "../src/EnglishAuction.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployEnglishAuction is Script {
    function run() public returns (EnglishAuction) {
        HelperConfig helperConfig = new HelperConfig();
        address nftAddress;
        uint256 nftId;
        uint256 highestBid;
        (nftAddress, nftId, highestBid) = helperConfig.getConfigVariables();

        vm.startBroadcast();
        EnglishAuction englishAuction = new EnglishAuction(nftAddress, nftId, highestBid);
        vm.stopBroadcast();
        return englishAuction;
    }
}
