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
/// 160-164: hp
/// (0-31)
/// ---------------------------
/// 165-171: round
/// (0-127)
/// ---------------------------
/// 172-176: x-coordinate
/// (up to 31 positions)
/// 177-180: y-coordinate
/// (up to 15 positions)
/// ---------------------------
/// 181-184: direction
/// (0-15)
/// 185-188: action
/// (0-15)
/// ---------------------------
/// 189-252: hitbox
/// 8x8 = 64 bits
/// ---------------------------
/// 253: combo flag
/// ---------------------------
/// 254-255: turn flag (TO:DO - change to 1 bit)
/// 0 - reveal
/// 1 - commit red
/// 2 - commit blue
/// 3 - #
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
    uint256 internal constant HP_BITS = 0x1F << 160;

    /// @notice location of the round count bits
    uint256 internal constant ROUND_BITS = 0x7F << 165;

    /// @notice location of the x-coordinate bytes
    uint256 internal constant X_COORD_BITS = 0x1F << 172;

    /// @notice location of the y-coordinate bytes
    uint256 internal constant Y_COORD_BITS = 0xF << 177;

    /// @notice location of the direction bits (4 bits)
    uint256 internal constant DIRECTION_BITS = 0xF << 181;

    /// @notice location of the action bits (4 bits)
    uint256 internal constant ACTION_BITS = 0xF << 185;

    /// @notice location of the hitbox bits
    uint256 internal constant HITBOX_BITS = ((1 << 64) - 1) << 189;

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
        // TO;DO - Make this a constant
        (uint256 grid,) = Moves.getSpriteGrid(Direction.NONE, Action.NONE);
        // Set the player's hp to 31.
        matchData = _matchData.setHp(31).setRound(127).setX(0).setY(0).setDirection(Direction.NONE).setAction(
            Action.NONE
        ).setHitbox(grid).setCombo(0).setTurn(0);
    }

    /// @notice Initializes the match data for the blue player.
    /// @param _matchData The player's match data.
    /// @return matchData The updated match data.
    function initializeBlue(uint256 _matchData) internal pure returns (uint256 matchData) {
        // TO;DO - Make this a constant
        (uint256 grid,) = Moves.getSpriteGrid(Direction.NONE, Action.NONE);
        // Set the player's hp to 31.
        matchData = _matchData.setHp(31).setRound(127).setX(31).setY(0).setDirection(Direction.NONE).setAction(
            Action.NONE
        ).setHitbox(grid).setCombo(0).setTurn(0);
    }

    /// @notice Execute a round in a match.
    /// @param _currentFytherMatchData The current figther match data.
    /// @param _opponentFytherMatchData the opponent figther match data.
    /// @return currentFytherMatchData The updated current fighter match data.
    /// @return opponentFytherMatchData The updated opponent fighter match data.
    function executeRound(
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
    function setRound(uint256 _matchData, uint256 _round) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~ROUND_BITS) | (_round << 165);
    }

    /// @notice Set the x-coordinate of the fyter.
    /// @param _matchData The match data.
    /// @param _x The x-coordinate of the fyter.
    /// @return matchData The updated match data.
    function setX(uint256 _matchData, uint256 _x) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~X_COORD_BITS) | (_x << 172);
    }

    /// @notice Set the y-coordinate of the fyter.
    /// @param _matchData The match data.
    /// @param _y The y-coordinate of the fyter.
    /// @return matchData The updated match data.
    function setY(uint256 _matchData, uint256 _y) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~Y_COORD_BITS) | (_y << 177);
    }

    /// @notice Set the direction of the fyter move
    /// @param _matchData The match data.
    /// @param _direction The direction of the fyter move.
    /// @return matchData The updated match data.
    function setDirection(uint256 _matchData, Direction _direction) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~DIRECTION_BITS) | (uint256(_direction) << 181);
    }

    /// @notice Set the action of the fyter move
    /// @param _matchData The match data.
    /// @param _action The action of the fyter
    /// @return matchData The updated match data.
    function setAction(uint256 _matchData, Action _action) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~ACTION_BITS) | (uint256(_action) << 185);
    }

    /// @notice Set the hitbox of the fyter.
    /// @param _matchData The match data.
    /// @param _hitbox The hitbox of the fyter.
    /// @return matchData The updated match data.
    function setHitbox(uint256 _matchData, uint256 _hitbox) internal pure returns (uint256 matchData) {
        matchData = (_matchData & ~HITBOX_BITS) | (_hitbox << 189);
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
    function getRound(uint256 _matchData) internal pure returns (uint256 round) {
        round = uint8((_matchData & ROUND_BITS) >> 165);
    }

    /// @notice Get the x and y coordinates of the fyter.
    /// @param _matchData The match data.
    /// @return x The x coordinate of the fyter.
    /// @return y The y coordinate of the fyter.
    function getCoordinates(uint256 _matchData) internal pure returns (uint256 x, uint256 y) {
        x = (_matchData & X_COORD_BITS) >> 172;
        y = (_matchData & Y_COORD_BITS) >> 177;
    }

    /// @notice Get the direction of the fyter move
    /// @param data The match data.
    /// @return direction The direction of the fyter move.
    function getDirection(uint256 data) internal pure returns (Direction direction) {
        direction = Direction((data & DIRECTION_BITS) >> 181);
    }

    /// @notice Get the action of the fyter move
    /// @param data The match data.
    /// @return action The action of the fyter
    function getAction(uint256 data) internal pure returns (Action action) {
        action = Action((data & ACTION_BITS) >> 185);
    }

    /// @notice Get the hitbox of the fyter.
    /// @param _matchData The match data.
    /// @return hitbox The hitbox of the fyter.
    function getHitbox(uint256 _matchData) internal pure returns (uint256 hitbox) {
        hitbox = (_matchData & HITBOX_BITS) >> 189;
    }

    /// @notice Check if the fyter is in a combo state.
    /// @param _matchData The match data.
    /// @return combo Whether the fyter is in a combo or not.
    function getCombo(uint256 _matchData) internal pure returns (uint256 combo) {
        combo = (_matchData & COMBO_BIT) >> 253;
    }

    /// @notice Get the turn flag of the fyter.
    /// @param _matchData The match data.
    /// @return turn The turn flag of the match.
    function getTurn(uint256 _matchData) internal pure returns (uint256 turn) {
        turn = (_matchData & TURN_FLAG) >> 254;
    }
}
