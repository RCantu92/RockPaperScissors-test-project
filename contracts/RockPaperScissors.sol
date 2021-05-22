// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// PERHAPS NOT NEEDED?
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// ONLY FOR TESTING
import "hardhat/console.sol";

contract RockPaperScissors {

    // IS THIS SUPPOSED TO BE IERC20 OR ERC20?
    // Creating instance of the deployed $LINK
    // token on the kovan Ethereum testnet
    IERC20 public kovanLink = IERC20(0xa36085F69e2889c224210F603D836748e7dC0088);

    // KEEP THIS ONLY FOR THE TEST?
    address _mostRecentWinner;
    // GETTER FUNCTION BECAUSE ETHERS WOULDN'T CALL
    // A VARIABLE
    function mostRecentWinner() public view returns(address) {
        return _mostRecentWinner;
    }

    uint internal playerNumber;
    mapping(uint => Player) internal players;

    struct Player {
        uint playerNumber;
        address payable playerAddress;
        string chosenItem;
    }

    /*
    // FUNCTION ONLY FOR TESTING
    // (COULD NOT CALL MAPPING WITH ETHERS,
    // HENCE THE GETTER FUNCTION)
    function _approvedLink(address _approver) public view returns(bool) {
        return approvedLink[_approver];
    }
    */

    /*
    // Approve contract to handle (kovan) $LINK
    // on user's behalf
    function approveLink() public {
        // DELETE
        console.log("Msg.sender calling approveLink() is %s", msg.sender);

        kovanLink.approve(address(this), 500000000000000000);
        approvedLink[msg.sender] = true;

        kovanLink.transfer(address(this), 3000000000000000000);
    }
    */

    // Play by submitting one of the
    // following:
    // ["Rock", "Paper", "Scissors"]
    // If no player has submitted an item,
    // store as player one, if player one has
    // already submitted an item, store as
    // player two.
    // Run paper rock scissors logic.
    function playPaperRockScissors(string memory _chosenItem) public payable returns (string memory) {

        // Require players submitted appropriate item
        require(
            areItemsAreEqual(_chosenItem, "rock") == true ||
            areItemsAreEqual(_chosenItem, "paper") == true ||
            areItemsAreEqual(_chosenItem, "scissors") == true,
            "You have either not input an appropriate item or item name not written in lowercase."
        );

        // TEST TO SEE WHO MSG.SENDER IS DELETE
        console.log(msg.sender);
        // Transfer a portion of one $LINK from player to contract address
        kovanLink.transferFrom(msg.sender, address(this), 50000000);

        // Check to see if a player has already
        // submitted item, if not, that player is
        // player one. If so, that player is
        // player two and game logic carries out.
        if(playerNumber > 0) {
            players[playerNumber] = Player(playerNumber, payable(msg.sender), _chosenItem);
            playerNumber ++;
            return "You are player two";

            // Call function that has paper, rock, scissors, logic
            gameLogic();
        } else {
            players[playerNumber] = Player(playerNumber, payable(msg.sender), _chosenItem);
            playerNumber ++;
            return "You are player one";
        }
    }

    // Function that houses rock, paper, scissors logic
    // then resets the number of players
    function gameLogic() internal {
        // Outcomes for if first player chose "rock"
        if(areItemsAreEqual(players[0].chosenItem, "rock") == true) {
            // If then player two chose "paper"
            if(areItemsAreEqual(players[1].chosenItem, "paper") == true) {
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "scissors"
            } else if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "rock"
            } else {
                // Tie, both players chose "rock"
            }
        // Outcomes for if first player chose "paper"
        } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
            // If then player two chose scissors
            if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "rock"
            } else if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "paper"
            } else {
                // Tie, both players chose "paper"
            }
        // Outcome for if first player chose "scissors"
        } else {
            // If then player two chose "rock"
            if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "paper"
            } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "scissors"
            } else {
                // Tie, both players chose "scissors"
            }
        }
    }

    // Function that would appropriately
    // distribute the winnings to the winner
    function disperseWinnings(address _winner) internal {
        // Reset number of players
        playerNumber = 0;
        // Store most recent winner
        _mostRecentWinner = _winner;
        // Player two wins the $LINK
        kovanLink.transferFrom(address(this), _winner, 100000000);
    }

    // function that compares the
    // hashes of two different strings
    function areItemsAreEqual(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        if(keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem))) {
            return true;
        } else {
            return false;
        }
    }
}