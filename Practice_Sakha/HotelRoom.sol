// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HotelRoom {
    address payable public owner;

    //keep track of the hotel room's occupancy status. 
    //For example, we'll determine whether the hotel room is "vacant" or "occupied".

    enum roomStatus {Vacant, Occupied}
    roomStatus currentStatus;

    constructor() {
        owner = payable(msg.sender);
        currentStatus = roomStatus.Vacant;
    }


    modifier OnlyWhenVacant {
        require(currentStatus == roomStatus.Vacant,"Not vacant");
        _;
    }

    //we can add a price to the hotel room. We'll specify that it costs 2 Ether. 
    //We'll do that with a new modifier:
    modifier Cost(uint256 _amount) {
        require(msg.value >= _amount,"Not enough ether");
        _;
    }

    //create a function that will book the hotel room. 
    // Also to pay the onwer when the room is booked
    function book() external payable OnlyWhenVacant Cost(2 ether) {

        currentStatus = roomStatus.Occupied;
        owner.transfer(msg.value);
        //Event Occupy
        emit Occupy(msg.sender, msg.value);
    }

    //let's create a notification that the hotel room was booked. 
    //Anyone will be able to subscribe to this notification to find out as soon as 
    //it has been booked. We can accomplish this with an event

    event Occupy(address _occupant, uint _value); 

}