
// ethers.js library is built into Hardhat. We want to import it...
const { ethers } = require("hardhat");

async function main() {

    // 1) Tell the script we want to deploy the freshmanNFT.sol contract
        // Hardhat will load up a contract instance (so we can deploy it)
    const contract = await ethers.getContractFactory("freshmanNFT");

    // 2) Deploy it
    const deployedContract = await contract.deploy();
    await deployedContract.deployed();

    // 3) Print the address of the deployed contract, in case you want to look it up later
    console.log("NFT Contract deployed to: ", deployedContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

//On remix, we connected to metamask, which informed our contract about:
    // Blockchain network, wallet address, RPC URL link to Ethereum
//Using hardhat, we must edit the config file hardhat.config.js