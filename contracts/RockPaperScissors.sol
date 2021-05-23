// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RockPaperScissors {

    // IS THIS SUPPOSED TO BE IERC20 OR ERC20?
    // Creating instance of the deployed $LINK
    // token on the kovan Ethereum testnet
    IERC20 kovanLink = IERC20(0xa36085F69e2889c224210F603D836748e7dC0088);

    // KEEP THIS ONLY FOR THE TEST?
    address _mostRecentWinner;
    // GETTER FUNCTION BECAUSE ETHERS WOULDN'T CALL
    // A VARIABLE
    function mostRecentWinner() public view returns(address) {
        return _mostRecentWinner;
    }

    // RETURN TO INTERNAL
    uint /*internal*/ public playerNumber;
    // RETURN TO INTERNAL
    mapping(uint => Player) /*internal*/ public players;

    struct Player {
        address payable playerAddress;
        string chosenItem;
    }

    // Mapping that stores whether player's last
    // game resulted in a tie
    // RETURN TO INTERNAL
    mapping(address => bool) /*internal*/ public playerVoucher;

    /*
    // FUNCTION ONLY FOR TESTING
    // (COULD NOT CALL MAPPING WITH ETHERS,
    // HENCE THE GETTER FUNCTION)
    function _approvedLink(address _approver) public view returns(bool) {
        return approvedLink[_approver];
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
    // (TRYING CALLDATA TO CHECK IF IT UPDATES STORED ITEM)
    function playPaperRockScissors(string /*memory*/ calldata _chosenItem) public payable {

        // Require players submitted appropriate item
        require(
            areItemsEqual(_chosenItem, "rock") == true ||
            areItemsEqual(_chosenItem, "paper") == true ||
            areItemsEqual(_chosenItem, "scissors") == true,
            "You have either not input an appropriate item or item name not written in lowercase."
        );

        // If players most recent game did not result in a tie,
        // transfer a portion of one $LINK from player to contract address
        if (playerVoucher[msg.sender] != true) {
            kovanLink.transferFrom(msg.sender, address(this), 50000000);
        }

        // Check to see if a player has already
        // submitted item, if not, that player is
        // player one. If so, that player is
        // player two and game logic carries out.
        if(playerNumber > 0) {
            players[playerNumber] = Player(payable(msg.sender), _chosenItem);
            
            // Call function that has paper, rock, scissors, logic
            gameLogic();
            
            // SINCE THE PLAYERNUMBER VARIABLE IS SET
            // TO 0, THIS LINE MAY BE UNECCESSARY
            // playerNumber ++;
        } else {
            players[playerNumber] = Player(payable(msg.sender), _chosenItem);
            playerNumber ++;
        }
    }

    // Function that houses rock, paper, scissors logic
    // then resets the number of players
    function gameLogic() internal {
        // Outcomes for if first player chose "rock"
        if(areItemsEqual(players[0].chosenItem, "rock") == true) {
            // If then player two chose "paper"
            if(areItemsEqual(players[1].chosenItem, "paper") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "scissors"
            } else if(areItemsEqual(players[1].chosenItem, "scissors") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "rock"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayersVoucher(players[0].playerAddress, players[1].playerAddress);
            }
        // Outcomes for if first player chose "paper"
        } else if(areItemsEqual(players[0].chosenItem, "paper") == true) {
            // If then player two chose scissors
            if(areItemsEqual(players[1].chosenItem, "scissors") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "rock"
            } else if(areItemsEqual(players[1].chosenItem, "rock") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "paper"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayersVoucher(players[0].playerAddress, players[1].playerAddress);
            }
        // Outcome for if first player chose "scissors"
        } else {
            // If then player two chose "rock"
            if(areItemsEqual(players[1].chosenItem, "rock") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[1].playerAddress);
            // If then player two chose "paper"
            } else if(areItemsEqual(players[0].chosenItem, "paper") == true) {
                removeVoucher(players[0].playerAddress, players[1].playerAddress);
                disperseWinnings(players[0].playerAddress);
            // If then player also chose "scissors"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayersVoucher(players[0].playerAddress, players[1].playerAddress);
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

    // Function that gives a player a voucher
    // to play a game without sending $LINK
    // to contract
    function givePlayersVoucher(address _tyingPlayerOne, address _tyingPlayerTwo) internal {
        // Reset number of players
        playerNumber = 0;
        
        // Store player address
        // so that next game, they
        // don't have to transfer $LINK
        // to the contract
        playerVoucher[_tyingPlayerOne] = true;
        playerVoucher[_tyingPlayerTwo] = true;
    }
    
    // Function to confirm players have no voucher
    // after completing legitimate game
    function removeVoucher(address _playerOneAddress, address _playerTwoAddress) internal {
        playerVoucher[_playerOneAddress] = false;
        playerVoucher[_playerTwoAddress] = false;
    }

    // Function that compares the
    // hashes of two different strings
    function areItemsEqual(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        return keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem));
        /*
        if(keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem))) {
            return true;
        } else {
            return false;
        }
        */
    }
}