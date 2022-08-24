const EternalZombiesMinter = artifacts.require('EternalZombies')
const Percentages = artifacts.require("Percentages");
const EternalZombiesStaker = artifacts.require('EternalZombiesStaker')
const EternalZombiesDistributor = artifacts.require('EternalZombiesDistributor')
const EternalZombiesRandomNumberGenerator = artifacts.require('EternalZombiesRandomNumberGenerator')

// test minter deployed at => 0xaD21D757B5e7dcddF7C2636fC1D5b0C4f7F586eb
// test staker deployed at => 0xd12d7aaBE5E406c99F62Dd26ADCF14Aa03CC1bFA
// test distributor deployed at => 0x8cB6d7CECeE7e4cd02E560D07e94B6921e99efC6

// Main net
// MINTER
const designer = '0xA97F7EB14da5568153Ea06b2656ccF7c338d942f' // replace it with CJs address
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

// random number generator

const _vrfCoordinator = '0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31'
const _linkToken = '0x404460C6A5EdE2D891e8297795264fDe62ADBB75'
const _keyHash = '0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c'
const _linkFee = '200000000000000000'


module.exports = async function (deployer) {

    // await deployer.deploy(EternalZombiesMinter, designer); // invalid designer address, change it later
    // await EternalZombiesMinter.deployed();


    // await deployer.deploy(EternalZombiesDistributor, zmbe)
    // const Distributor = await EternalZombiesDistributor.deployed()
    //
    // await deployer.deploy(Percentages);
    // const percentages = await Percentages.deployed();
    //
    // await deployer.link(Percentages, EternalZombiesStaker);
    // await deployer.deploy(EternalZombiesStaker,
    //     wrappedBNB,
    //     zmbe,
    //     pancakeRouter,
    //     "0xb256Bf0E888c34FE67a4169f0A5f80AC9F9e2f6D", // invalid address , change it later
    //     drFrankenstein,
    //     pancakeLP,
    //     tombOverlay,
    //     reStakingPercentage,
    //     devPercentage,
    //     burnPercentage
    // )
    // const Staker = await EternalZombiesStaker.deployed()
    // Staker.getLPApproved()
    // Staker.getZMBEApproved()
    // await deployer.deploy(EternalZombiesMinter, maxSupply, Staker.address, forTeam)

    await deployer.deploy(EternalZombiesRandomNumberGenerator,
        _vrfCoordinator,
        _linkToken,
        _keyHash,
        _linkFee
    )

};