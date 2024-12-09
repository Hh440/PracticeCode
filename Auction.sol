// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auction{
    address public owner;
    uint public startingAmount;
    uint public maxAmount;
    address public  highestBidder;

     bool endAuction ;
    

    constructor(uint _startingAmount) payable {
        owner=msg.sender;
        startingAmount=_startingAmount;
        maxAmount=startingAmount;
        highestBidder=address(0);

        endAuction=false;

    }

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;

    }

    modifier auctionOngoing(){
         require(endAuction==false,"Auction is not open");
         _;
    }


    function refund(address previousBidder, uint amount) internal  auctionOngoing{
       
        payable (previousBidder).transfer(amount);

    }

    function bid() public payable  auctionOngoing {
         require(msg.sender != owner, "Owner cannot place bids");
        require(msg.value>maxAmount,"Bid the amount higher the current highest bid");
        if(highestBidder!=address(0)){
            refund(highestBidder, maxAmount);
        }

        maxAmount=msg.value;
        highestBidder=msg.sender;
    
    }

    function bidder() public view returns (address){
        return highestBidder;
    }


    function endFunc() public  onlyOwner auctionOngoing{
        endAuction=true;

        payable (owner).transfer(maxAmount);
       


    }
    

    
}