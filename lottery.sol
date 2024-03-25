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
        require(participants.length >= 1, "You need at least 1 participant");
        uint randomNumber = random(); 
        uint winnerIndex = randomNumber % participants.length;
        address payable winner = participants[winnerIndex];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
