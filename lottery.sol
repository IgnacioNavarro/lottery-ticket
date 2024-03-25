// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract Lottery { 
    
    address public owner; 
    address payable[] public participants;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Minimum amount to participat is 1 Ethereum");
        participants.push(payable(msg.sender)); 
    }

    modifier onlyOwner { 
        require(msg.sender == owner, "You are not the Owner");
        _;
    }

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function random() private view returns(uint) {
        return uint(keccak256( abi.encodePacked (block.difficulty, block.timestamp, participants.length)));
    }

    function lotteryWinner() public onlyOwner {
        //If the participants are equal or greater than 3 then other lines execute else the next line execute
        require(participants.length >= 1, "You need at least 1 participant");
        uint randomNumber = random(); 
        uint winnerIndex = randomNumber % participants.length;
        address payable winner = participants[winnerIndex];
        winner.transfer(getBalance()); //All amount which is in getBalance will transfer to the winner
        participants = new address payable[](0); //After the Lottery ends array will be 0
    }
}
