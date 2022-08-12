
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getRandom() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(owner == msg.sender);
        require(players.length >= 3);
        uint random = getRandom();
        uint index = random % players.length;
        address payable winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}
