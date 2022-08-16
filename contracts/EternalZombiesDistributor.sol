// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

interface IMinter {
    function balanceOf(address owner) external returns (uint256);
    function ownerOf(uint256 tokenId) external returns (address);
    function totalSupply() external returns (uint256);
}

contract EternalZombiesDistributor is Ownable {

    address public ZMBE;

    uint public EMISSION_RATE;

    constructor(
        address zmbe
    ) {
        ZMBE = zmbe;
    }


}