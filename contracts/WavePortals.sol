// SPDX-Licence Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address from;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Hey Hey Hey, Nimo made this smart Contract !!!!!");

        seed = (block.timestamp + block.difficulty) % 100;
    }



    function wave(string memory _message) public {

        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds before waving again");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves++;
        console.log("%s waved w/ message %s" , msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint256 prizeAmount = 0.0001 ether;

        seed = (seed + block.difficulty + block.timestamp) % 100;

        console.log("Random # generated:  %d.", seed);

        if(seed <= 50 ){

            console.log("%s Won!", msg.sender);

            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than contract has..."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");

            require(success, "Failed to withdraw money from contract...");
        }



        emit NewWave(msg.sender, block.timestamp, _message);

    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("We had total %d waves", totalWaves);
        return totalWaves;
    }
}