const EternalZombiesMinter = artifacts.require('EternalZombies')
const Percentages = artifacts.require("Percentages");
const EternalZombiesStaker = artifacts.require('EternalZombiesStaker')
const EternalZombiesDistributor = artifacts.require('EternalZombiesDistributor')
const EternalZombiesNftDistributor = artifacts.require('EternalZombiesNftLottery')

// test minter deployed at => 0xaD21D757B5e7dcddF7C2636fC1D5b0C4f7F586eb
// test staker deployed at => 0xd12d7aaBE5E406c99F62Dd26ADCF14Aa03CC1bFA // unverified
// test distributor deployed at => 0x8cB6d7CECeE7e4cd02E560D07e94B6921e99efC6

// first testmint trx https://bscscan.com/tx/0xc52ee020a6555c5db083685934d55ce9d3ce37ac5d94c0b468d36e719f86c7c6

// Main net
// Staker
const wrappedBNB = '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c'
const zmbe = '0x50ba8bf9e34f0f83f96a340387d1d3888ba4b3b5'
const pancakeRouter = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
const drFrankenstein = '0x590Ea7699A4E9EaD728F975efC573f6E34a5dC7B'
const pancakeLP = '0x4DBaf6479F0Afa9f03C2A7D611151Fa5b53ECdC8'
const tombOverlay = '0x2974b990787aeC9fAAf4f210F841095389768A5D'
const reStakingPercentage = 10
const burnPercentage = 2
const devPercentage = 3


module.exports = async function (deployer) {

    // await deployer.deploy(EternalZombiesMinter, "0x4DBaf6479F0Afa9f03C2A7D611151Fa5b53ECdC8"); // invalid staker address, change it later
    // await EternalZombiesMinter.deployed();


    // await deployer.deploy(EternalZombiesDistributor, zmbe)
    // const Distributor = await EternalZombiesDistributor.deployed()
    //
    await deployer.deploy(Percentages);
    const percentages = await Percentages.deployed();

    await deployer.link(Percentages, EternalZombiesStaker);
    await deployer.deploy(EternalZombiesStaker,
        wrappedBNB,
        zmbe,
        pancakeRouter,
        "0xb256Bf0E888c34FE67a4169f0A5f80AC9F9e2f6D", // invalid address , change it later
        drFrankenstein,
        pancakeLP,
        tombOverlay,
        reStakingPercentage,
        devPercentage,
        burnPercentage
    )
    // const Staker = await EternalZombiesStaker.deployed()
    Staker.getLPApproved()
    Staker.getZMBEApproved()
    // await deployer.deploy(EternalZombiesMinter, maxSupply, Staker.address, forTeam)

};