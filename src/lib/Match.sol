// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Libraries

import { Moves } from "./Moves.sol";

// Types

import { Direction, Action } from "../types/Types.sol";

/// @title Match logic library for Fyte
/// @author highskore
/// @notice This library contains the logic for playing Fyte matches.
/// @dev A fighter's match data is designed to fit into a single uint256, with the following bitpacking:
/// ---------------------------
/// 0-159: address of the fyter
/// ---------------------------
/// 160-167: hp (0-255)
/// ---------------------------
/// 168-174: round (0-255)
/// ---------------------------
/// 175-184: x-coordinate
/// 185-194: y-coordinate
/// ---------------------------
/// 195-198: direction
/// 199-202: action
/// ---------------------------
/// 203-251: hitbox
/// ---------------------------
/// 252: stunned flag
/// ---------------------------
/// 253: combo flag
/// ---------------------------
/// 254-255: turn flag (0 - me commit, 1 - opponent commit, 2 - me reveal, 3 - opponent reveal)
/// ---------------------------

library Match {
    /*//////////////////////////////////////////////////////////////
                                LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using Match for uint256;

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice location of the hp byte
    uint256 internal constant HP_BITS = 0xFF << 160;

    /// @notice location of the round count bits
    uint256 internal constant ROUND_BITS = 0xFF << 168;

    /// @notice location of the x-coordinate bytes
    uint256 internal constant X_COORD_BITS = 0x3FF << 175;

    /// @notice location of the y-coordinate bytes
    uint256 internal constant Y_COORD_BITS = 0x3FF << 185;

    /// @notice location of the direction bits (4 bits)
    uint256 internal constant DIRECTION_BITS = 0xF << 195;

    /// @notice location of the action bits (4 bits)
    uint256 internal constant ACTION_BITS = 0xF << 199;

    /// @notice location of the hitbox bits
    uint256 internal constant HITBOX_BITS = (1 << 49) - 1 << 203;

    /// @notice location of the stunned flag bit
    uint256 internal constant STUNNED_FLAG = 1 << 252;

    /// @notice location of the combo bit
    uint256 internal constant COMBO_BIT = 1 << 253;

    /// @notice location of the turn flag bits
    uint256 internal constant TURN_FLAG = 0x3 << 254;

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Error on trying to play when it's not your turn.
    error NotYourTurn();

    /// @notice Error on trying to play an invalid move.
    error InvalidMove();

    /// @notice Error when trying to play a game that's already over.
    error GameOver();

    /// @notice Error when trying to interact with a game that's still in progress.
    error GameInProgress();

    /*//////////////////////////////////////////////////////////////
                                 GAME LOGIC
    //////////////////////////////////////////////////////////////*/

    function isOver(uint256 _matchData, uint256 _matchData2) internal pure returns (bool) {
        return getHp(_matchData) == 0 || getHp(_matchData2) == 0;
    }

    /// @notice Initializes the match data for the red player.
    /// @param _matchData The player's match data.
    /// @return matchData The updated match data.
    function initializeRed(uint256 _matchData) internal pure returns (uint256 matchData) {
        // Set the player's hp to 255.
        matchData = _matchData.setHp(255);
        // Set the player's match round count to 255.
        matchData = matchData.setRound(255);
        // Set the player's x-coordinate to 0.
        matchData = matchData.setX(252);
        // Set the player's y-coordinate to 0.
        matchData = matchData.setY(4);
        // Set the player's direction to neutral.
        matchData = matchData.setDirection(Direction.NONE);
        // Set the player's action to idle.
        matchData = matchData.setAction(Action.NONE);
        // Set the player's hitbox
        (uint256 grid,) = Moves.getSpriteGrid(Direction.NONE, Action.NONE);
        matchData = matchData.setHitbox(grid);
        // Set the player's stunned flag to false.
        matchData = matchData.setStunned(0);
        // Set the player's combo flag to false.
        matchData = matchData.setCombo(0);
        // Set the turn flag to 0.
        matchData = matchData.setTurn(0);
    }

    /// @notice Initializes the match data for the blue player.
    /// @param _matchData The player's match data.
    /// @return matchData The updated match data.
    function initializeBlue(uint256 _matchData) internal pure returns (uint256 matchData) {
        // Set the player's hp to 255.
        matchData = _matchData.setHp(255);
        // Set the player's match round count to 255.
        matchData = matchData.setRound(255);
        // Set the player's x-coordinate to 0.
        matchData = matchData.setX(764);
        // Set the player's y-coordinate to 0.
        matchData = matchData.setY(4);
        // Set the player's direction to neutral.
        matchData = matchData.setDirection(Direction.NONE);
        // Set the player's action to idle.
        matchData = matchData.setAction(Action.NONE);
        // Set the player's hitbox
        (uint256 grid,) = Moves.getSpriteGrid(Direction.NONE, Action.NONE);
        matchData = matchData.setHitbox(grid);
        // Set the player's stunned flag to false.
        matchData = matchData.setStunned(0);
        // Set the player's combo flag to false.
        matchData = matchData.setCombo(0);
        // Set the turn flag to 3.
        matchData = matchData.setTurn(1);
    }

    /// @notice Play a move in a match.
    /// @param _currentFytherMatchData The current figther match data.
    /// @param _opponentFytherMatchData the opponent figther match data.
    /// @return currentFytherMatchData The updated current fighter match data.
    /// @return opponentFytherMatchData The updated opponent fighter match data.
    function playMove(
        uint256 _currentFytherMatchData,
        uint256 _opponentFytherMatchData
    )
        internal
        pure
        returns (uint256 currentFytherMatchData, uint256 opponentFytherMatchData)
    {
        // Check if the game is over.
        if (isOver(_currentFytherMatchData, _opponentFytherMatchData)) revert GameOver();

        // Retrieve the move direction and action for the current player from the match data.

        // Retrieve the move direction and action for the opponent player from the match data.;

        // Get the move hitbox and damage for the current player's move.

        // Get the move hitbox and damage for the opponent player's move.

        // Calculate moveSpeed as the inverse of the damage for each player using bitwise NOT.

        // Check if the move hitbox from the current player can hit the opponent player.

        // Update the match data for both players based on the move result.

        // Return the updated match data for both players.
        return (_currentFytherMatchData, _opponentFytherMatchData);
    }

    /*//////////////////////////////////////////////////////////////
                                 SETTERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Set the hp of the fyter.
    /// @param _matchData The match data.
    /// @param _hp The hp of the fyter.
    /// @return matchData The updated match data.
    function setHp(uint256 _matchData, uint256 _hp) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~HP_BITS) | (_hp << 160);
    }

    /// @notice Set the round of the match.
    /// @param _matchData The match data.
    /// @param _round The round of the match
    /// @return matchData The updated match data.
    function setRound(uint256 _matchData, uint8 _round) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~ROUND_BITS) | (uint256(_round) << 168);
    }

    /// @notice Set the x-coordinate of the fyter.
    /// @param _matchData The match data.
    /// @param _x The x-coordinate of the fyter.
    /// @return matchData The updated match data.
    function setX(uint256 _matchData, uint256 _x) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~X_COORD_BITS) | (_x << 175);
    }

    /// @notice Set the y-coordinate of the fyter.
    /// @param _matchData The match data.
    /// @param _y The y-coordinate of the fyter.
    /// @return matchData The updated match data.
    function setY(uint256 _matchData, uint256 _y) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~Y_COORD_BITS) | (_y << 185);
    }

    /// @notice Set the direction of the fyter move
    /// @param _matchData The match data.
    /// @param _direction The direction of the fyter move.
    /// @return matchData The updated match data.
    function setDirection(uint256 _matchData, Direction _direction) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~DIRECTION_BITS) | (uint256(_direction) << 195);
    }

    /// @notice Set the action of the fyter move
    /// @param _matchData The match data.
    /// @param _action The action of the fyter
    /// @return matchData The updated match data.
    function setAction(uint256 _matchData, Action _action) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~ACTION_BITS) | (uint256(_action) << 199);
    }

    /// @notice Set the hitbox of the fyter.
    /// @param _matchData The match data.
    /// @param _hitbox The hitbox of the fyter.
    /// @return matchData The updated match data.
    function setHitbox(uint256 _matchData, uint256 _hitbox) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~HITBOX_BITS) | (_hitbox << 203);
    }

    /// @notice Set the stunned flag of the fyter.
    /// @param _matchData The match data.
    /// @param _stunned The stunned flag of the fyter.
    /// @return matchData The updated match data.
    function setStunned(uint256 _matchData, uint256 _stunned) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~STUNNED_FLAG) | (_stunned << 252);
    }

    /// @notice Set the combo flag of the fyter.
    /// @param _matchData The match data.
    /// @param _combo The combo flag of the fyter.
    /// @return matchData The updated match data.
    function setCombo(uint256 _matchData, uint256 _combo) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~COMBO_BIT) | (_combo << 253);
    }

    /// @notice Set the turn flag of the fyter.
    /// @param _matchData The match data.
    /// @param _turn The turn flag of the match.
    /// @return matchData The updated match data.
    function setTurn(uint256 _matchData, uint256 _turn) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~TURN_FLAG) | (_turn << 254);
    }

    /*//////////////////////////////////////////////////////////////
                                 GETTERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Get the hp of the fyter.
    /// @param _matchData The match data.
    /// @return hp The hp of the fyter.
    function getHp(uint256 _matchData) internal pure returns (uint256 hp) {
        hp = (_matchData & HP_BITS) >> 160;
    }

    /// @notice Get the round of the match.s
    /// @param _matchData The match data.
    /// @return round The round of the match.
    function getRound(uint256 _matchData) internal pure returns (uint8 round) {
        round = uint8((_matchData & ROUND_BITS) >> 168);
    }

    /// @notice Get the x and y coordinates of the fyter.
    /// @param _matchData The match data.
    /// @return x The x coordinate of the fyter.
    /// @return y The y coordinate of the fyter.
    function getCoordinates(uint256 _matchData) internal pure returns (uint256 x, uint256 y) {
        x = (_matchData & X_COORD_BITS) >> 175;
        y = (_matchData & Y_COORD_BITS) >> 185;
    }

    /// @notice Get the direction of the fyter move
    /// @param data The match data.
    /// @return direction The direction of the fyter move.
    function getDirection(uint256 data) internal pure returns (Direction direction) {
        direction = Direction((data & DIRECTION_BITS) >> 195);
    }

    /// @notice Get the action of the fyter move
    /// @param data The match data.
    /// @return action The action of the fyter
    function getAction(uint256 data) internal pure returns (Action action) {
        action = Action((data & ACTION_BITS) >> 199);
    }

    /// @notice Get the hitbox of the fyter.
    /// @param _matchData The match data.
    /// @return hitbox The hitbox of the fyter.
    function getHitbox(uint256 _matchData) internal pure returns (uint256 hitbox) {
        hitbox = (_matchData & HITBOX_BITS) >> 203;
    }

    /// @notice Get the stunned flag of the fyter.
    /// @param _matchData The match data.
    /// @return stunned The stunned flag of the fyter.
    function getStunned(uint256 _matchData) internal pure returns (uint256 stunned) {
        stunned = (_matchData & STUNNED_FLAG) >> 252;
    }

    // The combo bit should be extracted as a boolean, not as a number. I'll modify that function accordingly:
    /// @notice Check if the fyter is in a combo state.
    /// @param _matchData The match data.
    /// @return combo Whether the fyter is in a combo or not.
    function isInCombo(uint256 _matchData) internal pure returns (bool combo) {
        combo = (_matchData & COMBO_BIT) != 0;
    }

    /// @notice Get the turn flag of the fyter.
    /// @param _matchData The match data.
    /// @return turn The turn flag of the match.
    function getTurn(uint256 _matchData) internal pure returns (uint256 turn) {
        turn = (_matchData & TURN_FLAG) >> 254;
    }
}
