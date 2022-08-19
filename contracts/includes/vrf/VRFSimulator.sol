/*
 *  Note:: To use this simulator, you must add this VERY unsafe function to your contract
 *
    // Function for testing ChainLink VRF on develop network
    function testRandomness(bytes32 _requestId, uint256 _randomNumber) public {
        fulfillRandomness(_requestId, _randomNumber);
    }
 *
 *  This function must NEVER EVER under ANY circumstances be deployed on an actual contract, or it entirely
 *  exposes the randomness to just be exploited. If you add this in for unit testing, it must be removed BEFORE
 *  your contract should be commited to the repo. No contract should EVER be in the repo with this functionality,
 *  just in case.
 *
 *  Otherwise just deploy it as part of your unit tests. The after you call the requestRandomness() in your contract, have
 *  the deployer call the finalize() function here with the same requestId and it will give you a pseudo-random number.
 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface VRFTarget {
    function testRandomness(bytes32 _requestId, uint256 _randomNumber) external;
}

contract VRFSimulator {
    VRFTarget target;
    bytes32 keyHash;
    
    constructor(address _target) { 
        target = VRFTarget(_target);
    }

    function finalize(bytes32 _id) public {
        target.testRandomness(_id, random());
    }
    
    function random() private view returns (uint256) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    }
}