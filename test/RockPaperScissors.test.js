const { ethers } = require("hardhat");
const { expect } = require("chai");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

describe("Rock, Paper, Scissors contract", function() {
    
    // Deploy contract before testing
    before(async function() {
        // Pull up RockPaperScissors contract code
        const rockPaperScissors = await ethers.getContractFactory("RockPaperScissors");

        // Pull some accounts
        // firstAccount will be the deployer
        [firstAccount, secondAccount] = await ethers.getSigners();

        // Deploye contract
        deployedGame = await rockPaperScissors.deploy();
    });

    it("should allow a player to approve contract to hold their $LINK", async function() {
        // firstAccount approves contract for 1 $LINK
        await deployedGame.approveLink();
        console.log(firstAccount.address);

        // secondAccount approves contract for 1 $LINK
        await deployedGame.connect(secondAccount).approveLink();
        console.log(secondAccount.address);

        // Confirm accounts have approved contract for 1 $LINK
        expect(await deployedGame._approvedLink(firstAccount.address)).to.equal(true);
        // console.log(await deployedGame.playerNumber);
        expect(await deployedGame._approvedLink(secondAccount.address)).to.equal(true);

    });
})