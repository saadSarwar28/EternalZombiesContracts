const EternalZombies = artifacts.require('EternalZombies')
const EternalZombiesStaker = artifacts.require('EternalZombiesStaker')
const EternalZombiesDistributor = artifacts.require('EternalZombiesDistributor')
// Testnet
const maxSupply = 1111
const forTeam = 111
const wrappedBNB = '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c'
const zmbe = '0x50ba8bf9e34f0f83f96a340387d1d3888ba4b3b5'
const pancakeRouter = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
const drFrankenstein = '0x590Ea7699A4E9EaD728F975efC573f6E34a5dC7B'
const pancakeLP = '0x4DBaf6479F0Afa9f03C2A7D611151Fa5b53ECdC8'
const reStakingPercentage = 10
const devPercentage = 5;


module.exports = async function (deployer) {

    // await deployer.deploy(EternalZombiesStaker,
    //     wrappedBNB,
    //     zmbe,
    //     pancakeRouter,
    //     '0xA97F7EB14da5568153Ea06b2656ccF7c338d942f',
    //     drFrankenstein,
    //     pancakeLP,
    //     reStakingPercentage,
    //     devPercentage
    // )
    // const StakingContract = await EternalZombiesStaker.deployed();
    //
    // await deployer.deploy(EternalZombies, maxSupply, StakingContract.address, forTeam)

};
