// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// To get to this point, we have already done some things in terminal:
    // Go to desired directory using cd command
    // Open npm by typing npm init
    // Install hardhat by typing npm install hardhat
    // open the vs studio IDE by typing code .
    // Launch a hardhat project by typing npx hardhat and following prompts
    // ...this will create a bunch of files and directories

// Now we create our contract file freshmanNFT.sol in the contracts folder (this file)

// To avoid reinventing the wheel, we import OpenZeppelin's standard implementation of ERC721
// In remix we imported this by copy/pasting the URL link of the contract page on github
// Now we are working with Hardhat on our local computer, so we can't do that
    // ...instead we use npm (on our Terminal) to install the node.js library of OpenZeppelin
    // npm install @openzeppelin/contracts
    // Once that is done, we can import it with the line below
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract freshmanNFT is ERC721 {

    constructor() ERC721("First Test Collection", "FTC") {
        _mint (msg.sender, 1);
        _mint (msg.sender, 2);
        _mint (msg.sender, 3);
    }
}

// How do we compile and deploy?
// On remix, we just went to the compile tab and to the deploy tab. With hardhat...
    // To compile, go back to terminal and type npx hardhat compile

    // To deploy, we write a script to deploy our contracts (more powerfull than remix)
    // ...go to the scripts folder and create a new file called deploy.js