// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

interface IPancakeSwapRouter {
    function getAmountsOut(uint amountIn, address[] memory path) external returns (uint[] memory amounts);
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint[] memory amounts);
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint[] memory amounts);
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IDrFrankenstein {
    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
        uint256 tokenWithdrawalDate;
        uint256 rugDeposited;
        bool paidUnlockFee;
        uint256  nftRevivalDate;
    }

    function deposit(uint256 _pid, uint256 _amount) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
    function userInfo(uint, address) external returns(UserInfo);
}

contract EternalZombiesStaker is Ownable {

    uint256 MAX_INT = 2**256 - 1;

    uint BNB_RECEIVED;
    uint ZMBE_BOUGHT;
    uint LP_BOUGHT;
    uint LP_STAKED;
    uint COMPOUNDED;

    address public ZMBE;
    address public WRAPPED_BNB;
    address public PANCAKE_ROUTER;
    address public MINTER;
    address public DISTRIBUTOR;
    address public DR_FRANKENSTEIN;
    address public PANCAKE_LP_TOKEN;

    uint public RESTAKE_PERCENTAGE;
    uint public FUNDING_WALLET_PERCENTAGE;

    uint public POOL_ID = 11;

    constructor(
        address wBNB,
        address zmbe,
        address router,
        address minter,
        address distributor,
        address tombs,
        address lp_tokens,
        uint restakePercentage,
        uint fundingWalletPercentage
    ) {
        WRAPPED_BNB = wBNB;
        ZMBE = zmbe;
        PANCAKE_ROUTER = router;
        MINTER = minter;
        DISTRIBUTOR = distributor;
        ZMBE_TOMBS = tombs;
        LP_TOKEN = lp_tokens;
        RESTAKE_PERCENTAGE = restakePercentage;
        FUNDING_WALLET_PERCENTAGE = fundingWalletPercentage;
    }

    function buyZMBE(uint bnbAmount) private returns(uint boughtAmount) {
        address[] memory path = new address[](2);
        path[0] = WRAPPED_BNB;
        path[1] = ZMBE;
        uint[] memory amountsOut = IPancakeSwapRouter(PANCAKE_ROUTER).getAmountsOut(bnbAmount, path);
        uint[] memory amounts = IPancakeSwapRouter(PANCAKE_ROUTER).swapExactETHForTokens{value : forBNBAmount}(
            amountsOut[1],
            path,
            address(this),
            block.timestamp + 10
        );
        return amounts[1];
    }

    function buyLPTokens(uint bnb, uint zmbe) public {
        IPancakeSwapRouter(PANCAKE_ROUTER).addLiquidityETH(bnb, zmbe);
    }

    function deposit() external payable {
        BNB_RECEIVED += msg.value;
        ZMBE_BOUGHT += buyZMBE((msg.value / 2));
        LP_BOUGHT += buyLPTokens();

    }

    function stake() private returns(uint compoundedAmount) {
        return 1;
    }

    function claimAndRestake() private returns(uint compoundedAmount) {
        return 1;
    }

    function sendTokensToDistributor() public onlyOwner() {
        IBEP20(ZMBE).transfer(DISTRIBUTOR, IBEP20(ZMBE).balanceOf(address(this)));
    }

    function withdrawRemainingZmbe() public onlyOwner() {
        IBEP20(ZMBE).transfer(msg.sender, IBEP20(ZMBE).balanceOf(address(this)));
    }

    function withdrawLpTokens() public onlyOwner() {
        IBEP20(PANCAKE_LP_TOKEN).transfer(msg.sender, IBEP20(PANCAKE_LP_TOKEN).balanceOf(address(this)));
    }

    function withdrawLpTokensFromPool() public onlyOwner() {
        IDrFrankenstein(DR_FRANKENSTEIN).withdraw(POOL_ID, IBEP20(PANCAKE_LP_TOKEN).balanceOf(address(this)));
    }

    function getZMBEApproved() public onlyOwner() {
        IBEP20(ZMBE).approve(PANCAKE_ROUTER, MAX_INT);
    }

    function getLPApproved() public onlyOwner() {
        IBEP20(PANCAKE_LP_TOKEN).approve(DR_FRANKENSTEIN, MAX_INT);
    }

}