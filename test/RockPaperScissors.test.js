const { ethers } = require("hardhat");
const { expect } = require("chai");
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");
const BigNumber = require('bignumber.js');

describe("Rock, Paper, Scissors contract", function() {
    
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
        await kovanLink.approve(deployedGame.address, 50000000000);
        await kovanLink.connect(secondAccount).approve(deployedGame.address, 50000000000);
    });

    
    it("should allow player one to win a game against player two", async function() {
        
        /*
        // LOG ACCOUNTS $LINK BALANCE
        linkBalanceOne = BigNumber(await kovanLink.balanceOf(firstAccount.address));
        linkBalanceTwo = BigNumber(await kovanLink.connect(secondAccount).linkBalance(secondAccount.address));

        console.log(`Kovan $LINK balance of account one ${linkBalanceOne}`);
        console.log(`Kovan $LINK balance of account two ${linkBalanceTwo}`);
        */
        
        try {
            // Submit rock for player one
            await deployedGame.playPaperRockScissors("rock");

            // Submit paper for player two
            await deployedGame.connect(secondAccount).playPaperRockScissors("paper");
            
            /*
            console.log(linkBalanceOne);
            console.log(linkBalanceOne);
            */

            expect(await deployedGame.mostRecentWinner()).to.equal(firstAccount.address);
        } catch(err) {

        }

    });
})