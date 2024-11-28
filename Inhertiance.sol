// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Inheritance{
    address recipent;
    address owner;
    uint will;
    uint startTime;
    bool oneYearComplete;

    modifier onlyOwn(){
         require(msg.sender == owner||owner==recipent, "Here it is owner");
    _;
    }
    constructor(address _recipent) payable {
        require(msg.value >= will, "Insufficient Ether provided");
        owner= msg.sender;
        recipent=_recipent;
        will=msg.value;
        startTime=block.timestamp;
        oneYearComplete=false;
        
    }

    function OwnerChange() public onlyOwn {
         require(!oneYearComplete, "Cannot change owner after funds are distributed");
        owner=recipent;
    }




    function TimeRest() public onlyOwn {
        startTime = block.timestamp;
        oneYearComplete = false;
    }

    function getTime() public view returns (uint){
        return startTime;

    }

    function getOwner() public view returns(address){
        return  owner;
    }

    function ping() public onlyOwn{
        require(!oneYearComplete,"One Year is alerady completed");
        require(block.timestamp>=startTime+0 days,"One year is not completed");

        oneYearComplete=true;

        drain(payable (recipent));

    }



    function drain(address payable ad) internal {
        payable (ad).transfer(will);
        will=0;
    }





}