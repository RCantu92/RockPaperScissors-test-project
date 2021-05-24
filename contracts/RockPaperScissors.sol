// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RockPaperScissors {

    // Creating instance of the deployed $LINK
    // token on the kovan Ethereum testnet
    IERC20 kovanLink = IERC20(0xa36085F69e2889c224210F603D836748e7dC0088);

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
    mapping(address => bool) /*internal*/ public _playerVoucher;

    // GETTER FUNCTION BECAUSE ETHERS WOULDN'T CALL
    // A MAPPING
    function playerVoucher(address _playerAddress) public view returns(bool) {
        return _playerVoucher[_playerAddress];
    }
    
    // Function to claim winnings
    function claimWinnings() public {
        require(msg.sender == _mostRecentWinner);
        
        // Player two wins the $LINK
        kovanLink.transfer(msg.sender, 5000000);
    }

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
        if (_playerVoucher[msg.sender] != true) {
            kovanLink.transferFrom(msg.sender, address(this), 5000000);
        }

        // Check to see if a player has already
        // submitted item, if not, that player is
        // player one. If so, that player is
        // player two and game logic carries out.
        if(playerNumber == 1) {
            players[playerNumber] = Player(payable(msg.sender), _chosenItem);
            
            // Call function that has paper, rock, scissors, logic
            gameLogic();
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
                removeVoucher(players[0].playerAddress);
                declareWinner(players[1].playerAddress);
            // If then player two chose "scissors"
            } else if(areItemsEqual(players[1].chosenItem, "scissors") == true) {
                removeVoucher(players[1].playerAddress);
                declareWinner(players[0].playerAddress);
            // If then player also chose "rock"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayerVoucher(players[0].playerAddress);
                givePlayerVoucher(players[1].playerAddress);
            }
        // Outcomes for if first player chose "paper"
        } else if(areItemsEqual(players[0].chosenItem, "paper") == true) {
            // If then player two chose scissors
            if(areItemsEqual(players[1].chosenItem, "scissors") == true) {
                removeVoucher(players[0].playerAddress);
                declareWinner(players[1].playerAddress);
            // If then player two chose "rock"
            } else if(areItemsEqual(players[1].chosenItem, "rock") == true) {
                removeVoucher(players[1].playerAddress);
                declareWinner(players[0].playerAddress);
            // If then player also chose "paper"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayerVoucher(players[0].playerAddress);
                givePlayerVoucher(players[1].playerAddress);
            }
        // Outcome for if first player chose "scissors"
        } else {
            // If then player two chose "rock"
            if(areItemsEqual(players[1].chosenItem, "rock") == true) {
                removeVoucher(players[0].playerAddress);
                declareWinner(players[1].playerAddress);
            // If then player two chose "paper"
            } else if(areItemsEqual(players[0].chosenItem, "paper") == true) {
                removeVoucher(players[1].playerAddress);
                declareWinner(players[0].playerAddress);
            // If then player also chose "scissors"
            } else {
                // Give players a voucher to play again
                // without sending in $LINK
                givePlayerVoucher(players[0].playerAddress);
                givePlayerVoucher(players[1].playerAddress);
            }
        }
    }

    // Function that would appropriately
    // distribute the winnings to the winner
    function declareWinner(address _winner) internal {
        // Reset number of players
        playerNumber = 0;
        
        // Store most recent winner
        _mostRecentWinner = _winner;
    }

    // Function that gives a player a voucher
    // to play a game without sending $LINK
    // to contract
    function givePlayerVoucher(address _playerAddress) internal {
        // Reset number of players
        playerNumber = 0;
        
        // Store player address
        // so that next game, they
        // don't have to transfer $LINK
        // to the contract
        _playerVoucher[_playerAddress] = true;
    }
    
    // Function to confirm players have no voucher
    // after completing legitimate game
    function removeVoucher(address _playerAddress) internal {
        _playerVoucher[_playerAddress] = false;
    }

    // Function that compares the
    // hashes of two different strings
    function areItemsEqual(string memory _playerChosenItem, string memory _comparedItem) internal pure returns(bool) {
        return keccak256(abi.encode(_playerChosenItem)) == keccak256(abi.encode(_comparedItem));
    }
}