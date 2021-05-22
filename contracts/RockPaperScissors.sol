// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// PERHAPS NOT NEEDED?
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// ONLY FOR TESTING
import "hardhat/console.sol";

contract RockPaperScissors {

    // IS THIS SUPPOSED TO BE IERC20 OR ERC20?
    // Creating instance of the deployed $LINK
    // token on the kovan Ethereum testnet
    IERC20 public kovanLink = IERC20(0xa36085F69e2889c224210F603D836748e7dC0088);

    /*
    USED THIS FUNCTION TO TEST ABILITY TO
    TRANSFER $LINK TO RECEPIENT
    function transferLink(address _to, uint _amount) public {
        kovanLink.transferFrom(msg.sender, _to, _amount);
    }
    */

    // KEEP THIS ONLY FOR THE TEST?
    address _mostRecentWinner;
    // GETTER FUNCTION BECAUSE ETHERS WOULDN'T CALL
    // A VARIABLE
    function mostRecentWinner() public view returns(address) {
        return _mostRecentWinner;
    }

    // Mapping storing which address have approved $LINK
    mapping(address => bool) public approvedLink;

    uint public playerNumber;
    // MAKE SURE STRUCT IS NOT PUBLIC
    mapping(uint => Player) players;

    struct Player {
        uint playerNumber;
        address payable playerAddress;
        string chosenItem;
        bool playerEntered;
    }

    // FUNCTION ONLY FOR TESTING
    // (COULD NOT CALL MAPPING WITH ETHERS,
    // HENCE THE GETTER FUNCTION)
    function _approvedLink(address _approver) public view returns(bool) {
        return approvedLink[_approver];
    }

    // Approve contract to handle (kovan) $LINK
    // on user's behalf
    function approveLink() public {
        // DELETE
        console.log("Msg.sender calling approveLink() is %s", msg.sender);

        kovanLink.approve(address(this), 500000000000000000);
        approvedLink[msg.sender] = true;

        kovanLink.transfer(address(this), 3000000000000000000);
    }

    // Play by submitting one of the
    // following:
    // ["Rock", "Paper", "Scissors"]
    // If no player has submitted an item,
    // store as player one, if player one has
    // already submitted an item, store as
    // player two.
    // Run paper rock scissors logic.
    function playPaperRockScissors(string memory _chosenItem) public payable returns (string memory) {

        // Approve to use (kovan) $LINK token in this game
        require(approvedLink[msg.sender] == true, "You have not approved contract for $LINK");

        // Require players submitted appropriate item
        require(
            areItemsAreEqual(_chosenItem, "rock") == true ||
            areItemsAreEqual(_chosenItem, "paper") == true ||
            areItemsAreEqual(_chosenItem, "scissors") == true,
            "You have either not input an appropriate item or item name not written in lowercase."
        );

        // Transfer one $LINK from player to contract address
        kovanLink.transferFrom(msg.sender, address(this), 500000000000000000);

        // Check to see if a player has already
        // submitted item, if not, that player is
        // player one. If so, that player is
        // player two and game logic carries out.
        if(playerNumber > 0) {
            players[playerNumber] = Player(playerNumber, payable(msg.sender), _chosenItem, true);
            playerNumber ++;
            return "You are player two";

            // Call function that has paper, rock, scissors, logic
            gameLogic();
        } else {
            players[playerNumber] = Player(playerNumber, payable(msg.sender), _chosenItem, true);
            playerNumber ++;
            return "You are player one";
        }
    }

    // function that housed rock, paper,scissors logic
    // then resets the number of players
    function gameLogic() internal {
        // Outcomes for if first player chose "rock"
        if(areItemsAreEqual(players[0].chosenItem, "rock") == true) {
            if(areItemsAreEqual(players[1].chosenItem, "paper") == true) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[1].playerAddress;
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[0].playerAddress;
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
                // Tie, both players chose "rock"
            }
        // Outcomes for if first player chose "paper"
        } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
            if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[1].playerAddress;
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[0].playerAddress;
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
            } else {
                // Tie, both players chose "paper"
            }
        // Outcome for if first player chose "scissors"
        } else {
            if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[1].playerAddress;
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
                // reset number of players
                playerNumber = 0;
                // Store most recent winner
                _mostRecentWinner = players[1].playerAddress;
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
            } else {
                // Tie, both players chose "scissors"
            }
        }
    }

    // function that handles the hashing
    function areItemsAreEqual(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        bool _areItemsAreEqual = keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem));
        return _areItemsAreEqual;
    }
}