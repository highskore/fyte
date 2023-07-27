// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Moves } from "./Moves.sol";

/// @title Match logic library for Fyte
/// @author highskore
/// @notice This library contains the logic for playing Fyte matches.
/// @dev A fighter's match data is designed to fit into a single uint256, with the following bitpacking:
/// ---------------------------
/// 0-159: address of the fyter
/// ---------------------------
/// 160-167: hp (0-255)
/// ---------------------------
/// 168-174: energy (0-127)
/// ---------------------------
/// 175: facing flag (0 - left, 1 - right)
/// ---------------------------
/// 176-185: x-coordinate
/// 186-195: y-coordinate
/// ---------------------------
/// 196-199: direction
/// 200-203: action
/// ---------------------------
/// 204-252: hitbox
/// ---------------------------
/// 253: stunned flag
/// ---------------------------
/// 254: combo flag
/// ---------------------------
/// 255: turn flag (0 - blue corner, 1 - red corner)
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

    /// @notice location of the energy bits (7 bits)
    uint256 internal constant ENERGY_BITS = 0x7F << 168;

    /// @notice location of the facing flag bit
    uint256 internal constant FACING_FLAG = 1 << 175;

    /// @notice location of the x-coordinate bytes
    uint256 internal constant X_COORD_BITS = 0x3FF << 176; // 10 bits

    /// @notice location of the y-coordinate bytes
    uint256 internal constant Y_COORD_BITS = 0x3FF << 186; // 10 bits

    /// @notice location of the direction bits (4 bits)
    uint256 internal constant DIRECTION_BITS = 0xF << 196;

    /// @notice location of the action bits (4 bits)
    uint256 internal constant ACTION_BITS = 0xF << 200;

    /// @notice location of the hitbox bits
    uint256 internal constant HITBOX_BITS = (1 << 49) - 1 << 204;

    /// @notice location of the stunned flag bit
    uint256 internal constant STUNNED_FLAG = 1 << 253;

    /// @notice location of the combo bit
    uint256 internal constant COMBO_BIT = 1 << 254;

    /// @notice location of the turn flag bit
    uint256 internal constant TURN_FLAG = 1 << 255;

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
        // Check if it's the player's turn.
        if (_currentFytherMatchData.getTurn() == 0) revert NotYourTurn();
        // Check if the game is over.
        if (isOver(_currentFytherMatchData, _opponentFytherMatchData)) revert GameOver();

        // Retrieve the move direction and action for the current player from the match data.
        Moves.Direction currentFigtherDirection = _currentFytherMatchData.getDirection();
        Moves.Action currentFigtherAction = _currentFytherMatchData.getAction();

        // Retrieve the move direction and action for the opponent player from the match data.
        Moves.Direction opponentFigtherDirection = _opponentFytherMatchData.getDirection();
        Moves.Action opponentFigtherAction = _opponentFytherMatchData.getAction();

        // Get the move hitbox and damage for the current player's move.
        (uint256 currentFigtherHitboxGrid, uint256 damage) =
            Moves.getSpriteGrid(currentFigtherDirection, currentFigtherAction);

        // Get the move hitbox and damage for the opponent player's move.
        (uint256 opponentFigtherHitboxGrid, uint256 opponentDamage) =
            Moves.getSpriteGrid(opponentFigtherDirection, opponentFigtherAction);

        // Calculate moveSpeed as the inverse of the damage for each player using bitwise NOT.
        uint256 currentFigtherMoveSpeed = ~damage;
        uint256 opponentFigtherMoveSpeed = ~opponentDamage;

        // Check if the move hitbox from the current player can hit the opponent player.

        // Update the match data for both players based on the move result.

        // Return the updated match data for both players.
        return (_currentFytherMatchData, _opponentFytherMatchData);
    }

    /// @notice Check if the grid of the current player's move can hit the opponent player.
    /// @param _currentFigtherHitboxGrid The current player's move hitbox grid.
    /// @param _opponentFigtherHitboxGrid The opponent player's move hitbox grid.

    /*//////////////////////////////////////////////////////////////
                                 GETTERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Get the hp of the fyter.
    /// @param _matchData The match data.
    /// @return hp The hp of the fyter.
    function getHp(uint256 _matchData) internal pure returns (uint256 hp) {
        hp = (_matchData & HP_BITS) >> 160;
    }

    /// @notice Get the energy of the fyter.
    /// @param _matchData The match data.
    /// @return energy The energy of the fyter.
    function getEnergy(uint256 _matchData) internal pure returns (uint8 energy) {
        energy = uint8((_matchData & ENERGY_BITS) >> 168);
    }

    /// @notice Get the facing direction of the fyter.
    /// @param _matchData The match data.
    /// @return facing The facing direction of the fyter (0 for left, 1 for right).
    function getFacing(uint256 _matchData) internal pure returns (uint8 facing) {
        facing = uint8((_matchData & FACING_FLAG) >> 175);
    }

    /// @notice Get the x and y coordinates of the fyter.
    /// @param _matchData The match data.
    /// @return x The x coordinate of the fyter.
    /// @return y The y coordinate of the fyter.
    function getCoordinates(uint256 _matchData) internal pure returns (uint256 x, uint256 y) {
        x = (_matchData & X_COORD_BITS) >> 176;
        y = (_matchData & Y_COORD_BITS) >> 186;
    }

    /// @notice Get the direction of the fyter move
    /// @param data The match data.
    /// @return direction The direction of the fyter move.
    function getDirection(uint256 data) internal pure returns (Moves.Direction direction) {
        direction = Moves.Direction((data & DIRECTION_BITS) >> 196);
    }

    /// @notice Get the action of the fyter move
    /// @param data The match data.
    /// @return action The action of the fyter
    function getAction(uint256 data) internal pure returns (Moves.Action action) {
        action = Moves.Action((data & ACTION_BITS) >> 200);
    }

    /// @notice Get the hitbox of the fyter.
    /// @param _matchData The match data.
    /// @return hitbox The hitbox of the fyter.
    function getHitbox(uint256 _matchData) internal pure returns (uint256 hitbox) {
        hitbox = (_matchData & HITBOX_BITS) >> 204;
    }

    /// @notice Get the stunned flag of the fyter.
    /// @param _matchData The match data.
    /// @return stunned The stunned flag of the fyter.
    function getStunned(uint256 _matchData) internal pure returns (uint256 stunned) {
        stunned = (_matchData & STUNNED_FLAG) >> 253;
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
    /// @return turn The turn flag of the fyter.
    function getTurn(uint256 _matchData) internal pure returns (uint256 turn) {
        turn = (_matchData & TURN_FLAG) >> 255;
    }
}
