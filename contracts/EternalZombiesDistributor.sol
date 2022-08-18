// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;


interface IBEP20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {

    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

interface IMinter {
    function balanceOf(address owner) external returns (uint256);
    function ownerOf(uint256 tokenId) external returns (address);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
    function totalSupply() external returns (uint256);
    function TOKEN_ID() external returns (uint);
}

contract EternalZombiesDistributor is Ownable, ReentrancyGuard {

    address public ZMBE;
    address public MINTER;
    address public STAKER;

    uint public TOTAL_ZMBE_DISTRIBUTED;

    uint public CYCLE_COUNT; // total cycle count, starts from one

    struct DistributionCycle {
        uint amountReceived; // total zmbe received for this cycle
        uint lastTokenId; // tokens ids less than or equal to eligible to claim this cycle amount
        uint distributionAmount; // zmbe to distribute for each token
        uint timeStamp; // creation timestamp of this cycle
    }

    // mapping to keep track of each cycle, latest ID is the CYCLE_COUNT
    mapping (uint => DistributionCycle) public distributionCycles;

    // mapping from token id to last claimed at timestamp
    mapping (uint => uint) public lastClaimedTimestamp;

    // mapping from token id to last cycle claimed
    mapping (uint => uint) public lastClaimed;

    constructor(
        address minter,
        address zmbe,
        address staker
    ) {
        MINTER = minter;
        ZMBE = zmbe;
        STAKER = staker;
    }

    function setMinterAddress(address minter) public onlyOwner {
        MINTER = minter;
    }

    function setStakerAddress(address minter) public onlyOwner {
        MINTER = minter;
    }

    function createDistributionCycle(uint amount) external {
        require(msg.sender == STAKER || msg.sender == owner());
        CYCLE_COUNT += 1;
        uint lastTokenId = IMinter(MINTER).TOKEN_ID();
        distributionCycles[CYCLE_COUNT] = DistributionCycle(
            amount,
            lastTokenId,
            amount / lastTokenId,
            block.timestamp
        );
    }

    function claim(uint tokenId) public {
        require(tokenId <= IMinter(MINTER).TOKEN_ID(), "EZ: invalid token id");
        require(tokenId <= distributionCycles[CYCLE_COUNT].lastTokenId, "EZ: not eligible for claim yet");
        uint index = lastClaimed[tokenId];
        if (index < 1) {
            // Handling starting edge case because there is no cycle at 0
            index += 1;
        }
        uint zmbeAmount;
        for (index; index <= CYCLE_COUNT; index++) {
            zmbeAmount += distributionCycles[index].distributionAmount;
        }
        lastClaimed[tokenId] = CYCLE_COUNT;
        sendZmbe(IMinter(MINTER).ownerOf(tokenId), zmbeAmount);
        updateTotalZmbeDistributed(zmbeAmount);
    }

    function sendZmbe(address _address, uint amount) private {
        IBEP20(ZMBE).transfer(_address, amount);
    }

    function updateTotalZmbeDistributed(uint amount) private {
        TOTAL_ZMBE_DISTRIBUTED += amount;
    }

    // emergency withdrawal function in case of any bug
    function withdrawZmbe() public onlyOwner() {
        IBEP20(ZMBE).transfer(msg.sender, IBEP20(ZMBE).balanceOf(address(this)));
    }
}