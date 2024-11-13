// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {EnglishAuction} from "../src/EnglishAuction.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract Interactions is Script {
    function run() public {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("EnglishAuction", block.chainid);

        callStart(mostRecentDeployed);
        callBid(mostRecentDeployed);
        callWithdraw(mostRecentDeployed);
        callEnd(mostRecentDeployed);
    }

    function callStart(address mostRecentDeployed) public {
        vm.startBroadcast();
        EnglishAuction(mostRecentDeployed).start();
        vm.stopBroadcast();
    }

    function callBid(address mostRecentDeployed) public {
        vm.startBroadcast();
        EnglishAuction(mostRecentDeployed).bid();
        vm.stopBroadcast();
    }

    function callWithdraw(address mostRecentDeployed) public {
        vm.startBroadcast();
        EnglishAuction(mostRecentDeployed).withdraw();
        vm.stopBroadcast();
    }

    function callEnd(address mostRecentDeployed) public {
        vm.startBroadcast();
        EnglishAuction(mostRecentDeployed).end();
        vm.stopBroadcast();
    }
}
