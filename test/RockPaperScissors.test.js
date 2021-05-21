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

        // Deploy contract
        deployedGame = await rockPaperScissors.deploy();
    });

    /*
    it("should allow two players to approve contract to hold their $LINK", async function() {
        // firstAccount approves contract for 1 $LINK
        await deployedGame.approveLink();

        // secondAccount approves contract for 1 $LINK
        await deployedGame.connect(secondAccount).approveLink();

        // Confirm accounts have approved contract for 1 $LINK
        expect(await deployedGame._approvedLink(firstAccount.address)).to.equal(true);
        expect(await deployedGame._approvedLink(secondAccount.address)).to.equal(true);

    });
    */

    it("should allow player one to win a game against player two", async function() {
        // First account approves contract for 1 $LINK
        await deployedGame.approveLink();

        // Second account approves contract for 1 $LINK
        await deployedGame.connect(secondAccount).approveLink();
        
        try {
            // Submit rock for player one
            await deployedGame.playPaperRockScissors("rock");

            // Submit paper for player two
            await deployedGame.connect(secondAccount).playPaperRockScissors("paper");

            expect(await deployedGame.mostRecentWinner()).to.equal(firstAccount.address);
        } catch(err) {
            
        }
    });
})