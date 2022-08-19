// SPDX-License-Identifier: MIT
/**
 * @title EternalZombiesNftDistributor
 * @author : saad sarwar
 */

pragma solidity ^0.8.0;


import "./includes/access/Ownable.sol";
import "./includes/interfaces/IERC721.sol";
import "./includes/token/BEP20/IBEP20.sol";
import "./includes/utils/ReentrancyGuard.sol";
import "./includes/vrf/VRFConsumerBase.sol";

interface IMinter {
    function balanceOf(address owner) external returns (uint256);
    function ownerOf(uint256 tokenId) external returns (address);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
    function totalSupply() external returns (uint256);
    function TOKEN_ID() external returns (uint);
}

contract EternalZombiesNftLottery is Ownable, ReentrancyGuard, VRFConsumerBase {

    address     public  MINTER;
    address     public  STAKER;
    uint256     public  linkFee;        // Chainlink VRF fee paid in LINK
    bytes32     public  keyHash;        // Chainlink VRF key hash
    uint        public  TOTAL_NFTS_DISTRIBUTED;

    uint        public RANDOM_NUMBER;
    uint        public WINNER_TOKEN_ID;
    uint        public REWARDED_TOKEN_ID;

    bytes32     public requestId;

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _linkFee,
        address minter,
        address staker
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) {
        MINTER = minter;
        STAKER = staker;
        keyHash = _keyHash;
        linkFee = _linkFee;
    }

    function setLinkFee(uint fee) public onlyOwner {
        linkFee = fee;
    }

    function setMinterAddress(address minter) public onlyOwner {
        MINTER = minter;
    }

    function setStakerAddress(address staker) public onlyOwner {
        STAKER = staker;
    }

    // Function for the owner to recover any LINK in the contract
    function recoverLink() public onlyOwner() {
        LINK.approve(msg.sender, LINK.balanceOf(address(this)));
        LINK.transfer(msg.sender, LINK.balanceOf(address(this)));
    }

    // Function to request a random number from Chainlink VRF for current distribution
    function requestRandomNumber() public nonReentrant() {
        require(LINK.balanceOf(address(this)) >= linkFee, "LINK balance not enough");
        requestId = requestRandomness(keyHash, linkFee);
    }

    // Function for the Chainlink VRF to return a random number to us
    function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
        requestId = _requestId;
        RANDOM_NUMBER = _randomNumber;
        WINNER_TOKEN_ID = (_randomNumber % (IMinter(MINTER).TOKEN_ID()));
    }

    function sendRewardedNft(address tokenAddress) public onlyOwner() {
        IERC721(tokenAddress).transferFrom(address(this), IMinter(MINTER).ownerOf(WINNER_TOKEN_ID), REWARDED_TOKEN_ID);
    }

    function setRewardedTokenId(uint tokenId) public {
        require(msg.sender == STAKER || msg.sender == owner(), "EZ: not owner");
        REWARDED_TOKEN_ID = tokenId;
    }

}