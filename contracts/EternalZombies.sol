
// SPDX-License-Identifier: MIT

/**
 * @title Eternal Zombies
 */


pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/security/ReentrancyGuard.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";


interface IStaker {
    function deposit() external payable;
}

contract EternalZombies is ERC721Enumerable, Ownable, ReentrancyGuard {

    uint public TOKEN_ID; // starts from the total supply of the previous contract

    uint256 public nftPrice;

    uint256 public whitelistPrice;

    uint256 public MAX_SUPPLY;

    bool public whitelistActive = true;

    bool public saleIsActive = true;

    address public STAKER;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Token URI
    string public baseTokenURI;

    constructor(uint256 maxNftSupply, uint publicSalePrice, uint _whitelistPrice, address staker) ERC721("Eternal Zombies", "EZS") {
        MAX_SUPPLY = maxNftSupply;
        nftPrice = publicSalePrice;
        whitelistPrice = _whitelistPrice;
        STAKER = staker;
    }

    function setStakerAddress(address staker) public onlyOwner {
        require(staker != address(0), "Cannot be a zero address");
        STAKER = staker;
    }

    function setSalePrice(uint price) public onlyOwner() {
        require(price > 0, "Cannot be zero");
        nftPrice = price;
    }

    function setWhitelistSalePrice(uint price) public onlyOwner() {
        require(price > 0, "Cannot be zero");
        whitelistPrice = price;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner() {
        baseTokenURI = _newBaseURI;
    }

    // fallback  function to set a particular token uri manually if something incorrect in one of the metadata files
    function setTokenURI(uint tokenID, string memory uri) public onlyOwner() {
        _tokenURIs[tokenID] = uri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            return _tokenURIs[tokenId];
        }
        return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId)));
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function flipWhitelistSaleState() public onlyOwner {
        whitelistActive = !whitelistActive;
    }

    function mintNFT(uint amount) public payable nonReentrant() {
        require(nftPrice != 0, "Minting price not set yet");
        require(STAKER != address(0), 'Staking contract address not set.');
        require(saleIsActive, "Sale must be active to mint nft");
        require(msg.value >= nftPrice * amount, "Not enough bnb balance");
        IStaker(STAKER).deposit{value: msg.value}();
        for (uint index = 0; index < amount; index++) {
            TOKEN_ID = TOKEN_ID + 1;
            require(TOKEN_ID <= MAX_SUPPLY, "Purchase would exceed max supply of NFTs");
            _safeMint(msg.sender, TOKEN_ID);
        }
    }

    // mint for function to mint an nft for a given address, can be called only by owner
    function mintFor(address _to) public onlyOwner() {
        require((TOKEN_ID + 1) <= MAX_SUPPLY, "Purchase would exceed max supply of NFTs");
        TOKEN_ID += 1;
        _safeMint(_to, TOKEN_ID);
    }

    // mass minting function, one for each address
    function massMint(address[] memory addresses) public onlyOwner() {
        uint index;
        for (index = 0; index < addresses.length; index++) {
            mintFor(addresses[index]);
        }
    }

}