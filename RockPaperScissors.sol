// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract RockPaperScissors {

    struct Player {
        uint playerNumber;
        address playerAddress;
        string chosenItem;
        bool playerEntered;
    }

    uint playerNumber;
    // MAKE SURE STRUCT IS NOT PUBLIC
    mapping(uint => Player) players;

    // Deposit $DAi

    // function that handles the hashing
    function compareItemHashes(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        bool itemsAreEqual = keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem));
        return itemsAreEqual;
    }

    // function that housed rock, paper,scissors logic
    function gameLogic() internal view {
        // Outcomes for if first player chose "rock"
        if(compareItemHashes(players[0].chosenItem, "rock") == true) {
            if(compareItemHashes(players[1].chosenItem, "paper") == true) {
                // Player Two wins
            } else if(keccak256(abi.encode(players[1].chosenItem)) == keccak256("scissors")) {
                // Player One wins
            } else {
                // Tie, both players chose "rock"
            }
        // Outcomes for if first player chose "paper"
        } else if(keccak256(abi.encode(players[0].chosenItem)) == keccak256("paper")) {
            if(keccak256(abi.encode(players[1].chosenItem)) == keccak256("scissors")) {
                // Player Two wins
            } else if(keccak256(abi.encode(players[1].chosenItem)) == keccak256("rock")) {
                // Player One wins
            } else {
                // Tie, both players chose "paper"
            }
        // Outcome for if first player chose "scissors"
        } else {
            if(keccak256(abi.encode(players[1].chosenItem)) == keccak256("rock")) {
                // Player Two wins
            } else if(keccak256(abi.encode(players[0].chosenItem)) == keccak256("paper")) {
                // Player One wins
            } else {
                // Tie, both players chose "scissors"
            }
        }
    }

    // Play by submitting one of the
    // following:
    // ["Rock", "Paper", "Scissors"]
    // If no player has submitted an item,
    // store as player one, if play one has
    // already submitted an item, store as
    // player two.
    // Run paper rock scissors logic.
    function playPaperRockScissors(string memory _chosenItem) public returns (string memory) {

        // Require players submitted appropriate item
        require(
            keccak256(abi.encode(_chosenItem)) == keccak256("rock") ||
            keccak256(abi.encode(_chosenItem)) == keccak256("paper") ||
            keccak256(abi.encode(_chosenItem)) == keccak256("scissors"),
            "You have either not input an appropriate item or item name not written in lowercase."
        );

        // Check to see if a player has already
        // submitted item, if not, that player is
        // player one. If so, that player is
        // player two
        if(playerNumber > 0) {
            players[playerNumber] = Player(playerNumber, msg.sender, _chosenItem, true);
            playerNumber ++;
            return "You are player two";

            // Call function that has paper, rock, scissors, logic
        } else {
            players[playerNumber] = Player(playerNumber, msg.sender, _chosenItem, true);
            playerNumber ++;
            return "You are player one";
        }


    }

    // Disperse winnings
}