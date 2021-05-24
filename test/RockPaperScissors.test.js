const { ethers } = require("hardhat");
const { expect } = require("chai");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

describe("Rock, Paper, Scissors contract", function() {

    // Adjusting time out period for tests
    // (was erroring out at 20000ms)
    this.timeout(1000000);
    
    // Deploy contract before testing
    before(async function() {
        // Pull up RockPaperScissors contract code
        const rockPaperScissors = await ethers.getContractFactory("RockPaperScissors");
        // Pull up already deployed instance of kovan $LINK token
        const kovanLink = await ethers.getContractAt("IERC20", "0xa36085F69e2889c224210F603D836748e7dC0088");

        // Pull some already funded kovan addresses
        // firstAccount will be the deployer
        [firstAccount, secondAccount] = await ethers.getSigners();

        // Deploy game contract
        deployedGame = await rockPaperScissors.deploy();

        // Have both players approve game contract
        // to handle their kovan $LINK
        // (provided allowance is restricted by javascript, currently.
        // will implement BigNumber later to use more $LINK)
        await kovanLink.approve(deployedGame.address, 100000000);
        await kovanLink.connect(secondAccount).approve(deployedGame.address, 100000000);
    });

    
    it("should allow player one to win a game against player two", async function() {

        // Submit rock for player one
        await deployedGame.playPaperRockScissors("paper");

        // Submit paper for player two
        await deployedGame.connect(secondAccount).playPaperRockScissors("rock");

        expect(await deployedGame.mostRecentWinner()).to.equal(firstAccount.address);

    });

    it("should allow player two to win a game against player one", async function() {

        // Submit rock for player one
        await deployedGame.playPaperRockScissors("paper");

        // Submit paper for player two
        await deployedGame.connect(secondAccount).playPaperRockScissors("scissors");

        expect(await deployedGame.mostRecentWinner()).to.equal(secondAccount.address);

    });

    it("should handle a tie correctly", async function() {

        // Submit rock for player one
        await deployedGame.playPaperRockScissors("rock");

        // Submit paper for player two
        await deployedGame.connect(secondAccount).playPaperRockScissors("rock");

        // Confirm both players received vouchers to not pay $LINK
        // to play next game since they both tied
        expect(await deployedGame.playerVoucher(firstAccount.address)).to.equal(true);
        expect(await deployedGame.playerVoucher(secondAccount.address)).to.equal(true);
    });

    /*
    it("should not allow the submittal of an item that is not 'rock', 'paper,' or 'scissors'", async function() {

        // Submit ineligible item for player one
        expect(await deployedGame.playPaperRockScissors("car")).to.throw("You have either not input an appropriate item or item name not written in lowercase.");

    });
    */
})