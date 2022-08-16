const EternalZombiesMinter = artifacts.require('EternalZombies')
const EternalZombiesStaker = artifacts.require('EternalZombiesStaker')
const EternalZombiesDistributor = artifacts.require('EternalZombiesDistributor')

// Mainnet
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

    // await deployer.deploy(EternalZombies, maxNfts, salePrice, staker);
    // await EternalZombies.deployed();

    await deployer.deploy(EternalZombiesDistributor, zmbe)
    const Distributor = await EternalZombiesDistributor.deployed()

    await deployer.deploy(EternalZombiesStaker,
        wrappedBNB,
        zmbe,
        pancakeRouter,
        Distributor.address,
        drFrankenstein,
        pancakeLP,
        reStakingPercentage,
        devPercentage
    )
    const Staker = await EternalZombiesStaker.deployed()

    await deployer.deploy(EternalZombiesMinter, maxSupply, Staker.address, forTeam)

};