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

    it("should allow a player to approve $LINK to be sent", async function() {
        // firstAccount approves contract for 1 $LINK
        await deployedGame.approveLink();

        // secondAccount approves contract for 1 $LINK
        // await deployedGame.approveLink().connect(secondAccount);

        // Confirm accounts have approved contract for 1 $LINK
        expect(await deployedGame._approvedLink(firstAccount.address)).to.equal(true);
        // expect(approvedLink(secondAccount.address)).to.equal(true);

    });
})