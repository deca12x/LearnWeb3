
require("@nomiclabs/hardhat-waffle")

// For security reasons, use environment variables (dotenv)
  // ...instead of hardcoding my url and private key below
  // ...go back to terminal and type npm install dotenv
  // My sensitive info will be stored in the .env file
  // In case I upload this project to github,
  // ...everything listed within .gitignore will not be uploaded
  // ...including .env

  //Load dotenv and configure it with the line below
require("dotenv").config();

// In metamask, you can see in settings that each chain network's URL is set by default
// Using hardhat, we can use a node provider like Alchemy (Ethereum API)
  // Signup/Login to Alchemy, then create app, then get the HTTP key
  // Create a .env file and paste HTTP key & my private key in there.

module.exports = {
  // 1) Select chain and network
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      // 2) Define user account
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    }
  }
};

// FINALLY WE CAN DEPLOY
  // Go to terminal and type:
  // npx hardhat run scripts/deploy.js --network rinkeby
  // Copy the contract address from terminal
  // Paste it on etherscan.io and testnets.opensea.io