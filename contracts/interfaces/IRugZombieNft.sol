// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IRugZombieNft {
    function totalSupply() external view returns (uint256);
    function reviveRug(address _to) external returns(uint);
    function transferOwnership(address newOwner) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);
}