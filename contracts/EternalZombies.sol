// SPDX-License-Identifier: MIT

/**
 * @title EternalZombies
 * @author : saad sarwar
 */


pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/security/ReentrancyGuard.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";
import "openzeppelin-solidity/contracts/utils/cryptography/MerkleProof.sol";

interface IStaker {
    function deposit() external payable returns(bool success);
}

interface IDistributor {
    function setCycleStart() external;
}

contract EternalZombies is ERC721Enumerable, Ownable, ReentrancyGuard {

    uint public TOKEN_ID;

    uint256 public MAX_SUPPLY = 1111;

    uint256 public nftPrice = 200_000_000_000_000_000; // 0.2 BNB

    uint256 public whitelistPrice = 150_000_000_000_000_000; // 0.15 BNB;

    bool public whitelistActive = true;

    mapping(address => bool) public whitelistClaimed;

    bool public saleIsActive = true;

    address public STAKER;

    address public DISTRIBUTOR;

    address payable public DESIGNER;

    uint public ALLOCATED_FOR_TEAM = 111;

    uint public DESIGNER_PERCENTAGE = 2;

    uint public TEAM_COUNT;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Token URI
    string public baseTokenURI;

    bytes32 public merkleRoot;

    constructor(address payable designer) ERC721("Eternal Zombies", "EZ") {
        DESIGNER = designer;
    }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setStakerAddress(address staker) public onlyOwner {
        STAKER = staker;
    }

    function setDistributor(address distributor) public onlyOwner() {
        DISTRIBUTOR = distributor;
    }

    function setDesignerAddress(address payable designer) public onlyOwner {
        DESIGNER = designer;
    }

    function setSalePrice(uint price) public onlyOwner() {
        nftPrice = price;
    }

    function setWhitelistSalePrice(uint price) public onlyOwner() {
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

    function whitelistMint(bytes32[] calldata _merkleProof) public payable nonReentrant {
        require(whitelistActive && whitelistPrice > 0, "EZ: Whitelist not active yet.");
        require(TOKEN_ID < MAX_SUPPLY, "EZ: Mint exceeds limits");
        require(STAKER != address(0), "EZ: Staking contract address not set");
        require(!whitelistClaimed[msg.sender], "EZ: Already Claimed");
        require(msg.value >= whitelistPrice, "EZ: Not enough balance");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "EZ: Invalid Proof");
        uint forDesigner = (msg.value / 100) * DESIGNER_PERCENTAGE;
        safeTransfer(DESIGNER, forDesigner);
        require(IStaker(STAKER).deposit{value: (msg.value - forDesigner)}(), "EZ: Staking Failure");
        if (TOKEN_ID == 0) {
            IDistributor(DISTRIBUTOR).setCycleStart();
        }
        whitelistClaimed[msg.sender] = true;
        mintFor(msg.sender);
    }

    function mint(uint amount) public payable nonReentrant() {
        require(nftPrice != 0, "EZ: Minting price not set yet");
        require(STAKER != address(0), "EZ: Staking contract address not set");
        require(saleIsActive, "EZ: Sale must be active to mint nft");
        require(msg.value >= nftPrice * amount, "EZ: Not enough balance");
        uint forDesigner = (msg.value / 100) * DESIGNER_PERCENTAGE;
        safeTransfer(DESIGNER, forDesigner);
        require(IStaker(STAKER).deposit{value: (msg.value - forDesigner)}(), "EZ: Staking Failure");
        require((TOKEN_ID + amount) <= MAX_SUPPLY, "EZ: Purchase would exceed max supply of NFTs");
        if (TOKEN_ID == 0) {
            IDistributor(DISTRIBUTOR).setCycleStart();
        }
        for (uint index = 0; index < amount; index++) {
            mintFor(msg.sender);
        }
    }

    function safeTransfer(address _recipient, uint _amount) private {
        (bool _success, ) = _recipient.call{value: _amount}("");
        require(_success, "EZ: BNB Transfer failed.");
    }

    function mintFor(address _to) private {
        TOKEN_ID += 1;
        _safeMint(_to, TOKEN_ID);
    }

    // mass minting function, one for each address
    function massMint(address[] memory addresses) public onlyOwner() {
        uint index;
        require((TEAM_COUNT + addresses.length) <= ALLOCATED_FOR_TEAM && (TOKEN_ID + addresses.length) <= MAX_SUPPLY, "Amount exceeds allocation");
        for (index = 0; index < addresses.length; index++) {
            mintFor(addresses[index]);
            TEAM_COUNT += 1;
        }
    }

}