const EternalZombiesMinter = artifacts.require('EternalZombies')
const Percentages = artifacts.require("Percentages");
const EternalZombiesStaker = artifacts.require('EternalZombiesStaker')
const EternalZombiesDistributor = artifacts.require('EternalZombiesDistributor')

// Main net
const EZRandomNumGenerator = '0x9e9c3E8b5532b87fAa07e7899C4A05e4711D4675'

// Testnet
// const EZRandomNumGenerator = '0xd93D2C54264347C7940A026682314d62c002404e'

// first test mint trx https://bscscan.com/tx/0xc52ee020a6555c5db083685934d55ce9d3ce37ac5d94c0b468d36e719f86c7c6

// Main net

// MINTER
const designer = '0xA97F7EB14da5568153Ea06b2656ccF7c338d942f' //  <= YOUR ADDRESS
// const designer = '0xE13A249781062F8096CAA2604e19A95D8DA85beF' //  <= CANADIAN CRYPTO JUNKIE'S ADDRESS

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

    await deployer.deploy(EternalZombiesMinter, designer); // check if its CJs address
    await EternalZombiesMinter.deployed();

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

};

// for testing the updated distributor
// minter => https://bscscan.com/address/0x66E70a57e3cB9c8b0bD36d6C98388BB738eaAa28
// staker => https://bscscan.com/address/0x25423f02468f8de47f75206de4d9a3e638c50a22#code
// distributor => https://bscscan.com/address/0xcd63f97e825e82ab177fd2db42bf525116859c5f#code
