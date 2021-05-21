// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RockPaperScissors {

    // IS THIS SUPPOSED TO BE IERC20 OR ERC20?
    // Creating instance of the $LINK token
    // on the kovan Ethereum testnet
    ERC20 kovanLink = ERC20(0xa36085F69e2889c224210F603D836748e7dC0088);

    // Mapping storing which address have approved $LINK
    mapping(address => bool) public approvedLink;

    function _approvedLink(address _approver) public view returns(bool) {
        return approvedLink[_approver];
    }


    struct Player {
        uint playerNumber;
        address payable playerAddress;
        string chosenItem;
        bool playerEntered;
    }

    uint public playerNumber;
    // MAKE SURE STRUCT IS NOT PUBLIC
    mapping(uint => Player) players;

    // Approve contract to handle (kovan) $LINK
    // on user's behalf
    function approveLink() public {
        kovanLink.approve(msg.sender, 500000000000000000);
        approvedLink[msg.sender] = true;
    }

    // function that handles the hashing
    function areItemsAreEqual(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        bool _areItemsAreEqual = keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem));
        return _areItemsAreEqual;
    }

    // function that housed rock, paper,scissors logic
    function gameLogic() internal {
        // Outcomes for if first player chose "rock"
        if(areItemsAreEqual(players[0].chosenItem, "rock") == true) {
            if(areItemsAreEqual(players[1].chosenItem, "paper") == true) {
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
            } else {
                // Tie, both players chose "rock"
            }
        // Outcomes for if first player chose "paper"
        } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
            if(areItemsAreEqual(players[1].chosenItem, "scissors")) {
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
            } else {
                // Tie, both players chose "paper"
            }
        // Outcome for if first player chose "scissors"
        } else {
            if(areItemsAreEqual(players[1].chosenItem, "rock")) {
                // Player Two wins 1 $LINK
                kovanLink.transferFrom(address(this), players[1].playerAddress, 1000000000000000000);
            } else if(areItemsAreEqual(players[0].chosenItem, "paper")) {
                // Player One wins 1 $LINK
                kovanLink.transferFrom(address(this), players[0].playerAddress, 1000000000000000000);
            } else {
                // Tie, both players chose "scissors"
            }
        }
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
}