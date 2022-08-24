// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract EternalZombiesRandomNumberGenerator is Ownable, ReentrancyGuard, VRFConsumerBase {

    uint256     public  linkFee;        // Chainlink VRF fee paid in LINK
    bytes32     public  keyHash;        // Chainlink VRF key hash

    mapping (bytes32 => uint256) public result; //  mapping from requestId to results.

    mapping (address => bool) public allowedContracts;

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _linkFee
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) {
        keyHash = _keyHash;
        linkFee = _linkFee;
    }

    function setLinkFee(uint fee) public onlyOwner() {
        linkFee = fee;
    }

    function setAllowed(address _address, bool _allowed) public onlyOwner() {
        allowedContracts[_address] = _allowed;
    }

    // Function for the owner to recover any LINK in the contract
    function recoverLink() public onlyOwner() {
        LINK.approve(msg.sender, LINK.balanceOf(address(this)));
        LINK.transfer(msg.sender, LINK.balanceOf(address(this)));
    }

    // Function to request a random number from Chainlink VRF. save requestId in calling contract to get the results later
    // Contact devs at eternalzombies.com discord/telegram channel to get allowed if you want to use this contract for VRF.
    function requestRandomNumber() public nonReentrant() returns (bytes32 requestId) {
        require(allowedContracts[msg.sender], "EZ: address not allowed");
        require(LINK.balanceOf(address(this)) >= linkFee, "EZ: LINK balance not enough");
        requestId = requestRandomness(keyHash, linkFee);
        return requestId;
    }

    // Function for the Chainlink VRF to return a random number. random number mapped to requestId
    function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
        result[_requestId] = _randomNumber;
    }

}