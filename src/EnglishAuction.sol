// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/*  Auction
Seller of NFT deploys this contract.
Auction lasts for 7 days.
Participants can bid by depositing ETH greater than the current highest bidder.
All bidders can withdraw their bid if it is not the current highest bid. */

/*  After the auction
Highest bidder becomes the new owner of NFT.
The seller receives the highest bid of ETH. */

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address, address, uint256) external;
}

contract EnglishAuction {
    error EnglishAuction__NotStarted();
    error EnglishAuction__NotSeller();
    error EnglishAuction__AlreadyStarted();
    error EnglishAuction__Ended();
    error EnglishAuction__ValueMustBeMore();
    error EnglishAuction__NotEnded();

    event Start(bool started);
    event Bid(address indexed sender, uint256 amount);
    event Withdraw(address indexed bidder, uint256 amount);
    event End(address winner, uint256 amount);

    IERC721 private nft;
    uint256 public nftId;

    uint256 private withdrawBal;

    address payable private seller;
    uint256 private endAt;
    bool private started;
    bool private ended;

    address private highestBidder;
    uint256 private highestBid;
    mapping(address => uint256) private bids;

    constructor(address _nft, uint256 _nftId, uint256 _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        if (started == true) {
            revert EnglishAuction__AlreadyStarted();
        }
        if (msg.sender != seller) {
            revert EnglishAuction__NotSeller();
        }
        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start(started);
    }

    function bid() external payable {
        if (started != true) {
            revert EnglishAuction__NotStarted();
        }
        if (block.timestamp >= endAt) {
            revert EnglishAuction__Ended();
        }
        if (msg.value <= highestBid) {
            revert EnglishAuction__ValueMustBeMore();
        }

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        withdrawBal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: withdrawBal}("");
        require(success);
        emit Withdraw(msg.sender, withdrawBal);
    }

    function end() external {
        if (started != true) {
            revert EnglishAuction__NotStarted();
        }
        if (block.timestamp < endAt) {
            revert EnglishAuction__NotEnded();
        }
        if (ended == true) {
            revert EnglishAuction__Ended();
        }

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }

    //////////////////////////////////////////////////////
    ////////////////// Getter Functions //////////////////
    //////////////////////////////////////////////////////

    function getSeller() external view returns (address) {
        return seller;
    }

    function getEndAt() external view returns (uint256) {
        return endAt;
    }

    function getStarted() external view returns (bool) {
        return started;
    }

    function getEnded() external view returns (bool) {
        return ended;
    }

    function getMsgValue() public payable returns (uint256) {
        return msg.value;
    }

    function getHighestBid() external view returns (uint256) {
        return highestBid;
    }

    function getMsgSender() external view returns (address) {
        return msg.sender;
    }

    function getHighestBidder() external view returns (address) {
        return highestBidder;
    }

    function getWithdrawBal() external view returns (uint256) {
        return withdrawBal;
    }

    function getBidsMapping(address _address) external view returns (uint256) {
        return bids[_address];
    }

    function getNft() external view returns (IERC721) {
        return nft;
    }
}
