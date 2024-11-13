// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {EnglishAuction} from "../src/EnglishAuction.sol";
import {DeployEnglishAuction} from "../script/DeployEnglishAuction.s.sol";
import {Interactions} from "../script/Interactions.s.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract EnglishAuctionTest is Test {
    DeployEnglishAuction public deployEnglishAuction;
    EnglishAuction public englishAuction;
    Interactions public interactions;
    IERC721 public nft;

    address seller = address(1);
    address buyer = address(2);

    uint256 public constant INTERVAL = 7 days;

    event Start(bool started);

    function setUp() public {
        deployEnglishAuction = new DeployEnglishAuction();
        englishAuction = deployEnglishAuction.run();
        interactions = new Interactions();
    }

    modifier testStartIfElseStatements() {
        if (englishAuction.getStarted()) {
            vm.prank(englishAuction.getSeller());
            englishAuction.start();
        }
        _;
    }

    function testStartRevertsIfAlreadyStarted() public {
        if (englishAuction.getStarted()) {
            vm.expectRevert(EnglishAuction.EnglishAuction__AlreadyStarted.selector);
            englishAuction.start();
        }
    }

    function teststartStarted() public testStartIfElseStatements {
        bool started = englishAuction.getStarted();
        assertEq(started, false);
    }

    function testStartRevertsIfNotSeller() public {
        vm.expectRevert(EnglishAuction.EnglishAuction__NotSeller.selector);
        englishAuction.start();
    }

    function testBidRevertsIfNotStarted() public {
        vm.expectRevert(EnglishAuction.EnglishAuction__NotStarted.selector);
        englishAuction.bid();
    }

    // function testBidRevertsIfEnded() public {
    //     testBidRevertsIfNotStarted();

    //     vm.warp(block.timestamp + INTERVAL + 1); // sets block.timestamp // current block + 30 seconds + 1 seconds
    //     vm.roll(block.number + 1);

    //     vm.expectRevert(EnglishAuction.EnglishAuction__Ended.selector);
    //     englishAuction.bid();
    // }
}
