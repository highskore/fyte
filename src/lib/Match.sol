// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Match logic library for Fyte
/// @author highskore
/// @notice This library contains the logic for playing Fyte matches.
/// @dev A fighter's match data is designed to fit into a single uint256, with the following bitpacking:
/// ---------------------------
/// 0-159: address of the fyter
/// ---------------------------
/// 160-167: hp (0-255)
/// ---------------------------
/// 168-175: energy
/// ---------------------------
/// 176-191: x-coordinate
/// 192-207: y-coordinate
/// ---------------------------
/// 208-211: direction
/// 212-215: action
/// ---------------------------
/// 216-231: round
/// ---------------------------
/// 232: facing flag (0 - left, 1 - right)
/// 233: stunned flag
/// 234: airborne flag
/// ---------------------------
/// 235-236: buff
/// 237-239: combo
/// ---------------------------
/// 240: turn flag (0 - blue corner, 1 - red corner)
/// ---------------------------
/// 241-255: (empty for now but probably todo: figther type ?)
/// ---------------------------

library Match {
    /*//////////////////////////////////////////////////////////////
                                LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using Match for uint256;

    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/

    enum Direction {
        NONE,
        UP_LEFT,
        UP,
        UP_RIGHT,
        MIDDLE_LEFT,
        MIDDLE,
        MIDDLE_RIGHT,
        BOTTOM_LEFT,
        BOTTOM,
        BOTTOM_RIGHT
    }

    enum Action {
        NONE,
        LH,
        RH,
        LL,
        RL,
        LH_RH,
        LH_LL,
        LH_RL,
        RH_LL,
        RH_RL
    }

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice location of the hp byte
    uint256 internal constant HP_BITS = 0xFF << 160;

    /// @notice location of the energy byte
    uint256 internal constant ENERGY_BITS = 0xFF << 168;

    /// @notice location of the x-coordinate bytes
    uint256 internal constant X_COORD_BITS = 0xFFFF << 176;

    /// @notice location of the y-coordinate bytes
    uint256 internal constant Y_COORD_BITS = 0xFFFF << 192;

    /// @notice location of the direction bits (4 bits)
    uint256 internal constant DIRECTION_BITS = 0xF << 208;

    /// @notice location of the action bits (3 bits)
    uint256 internal constant ACTION_BITS = 0x7 << 212;

    /// @notice location of the round number bytes
    uint256 internal constant ROUND_BITS = 0xFFFF << 216;

    /// @notice location of the facing flag bit
    uint256 internal constant FACING_FLAG = 1 << 232;

    /// @notice location of the stunned flag bit
    uint256 internal constant STUNNED_FLAG = 1 << 233;

    /// @notice location of the airborne flag bit
    uint256 internal constant AIRBORNE_FLAG = 1 << 234;

    /// @notice location of the buff bits
    uint256 internal constant BUFF_BITS = 3 << 235;

    /// @notice location of the combo bits
    uint256 internal constant COMBO_BITS = 7 << 237;

    /// @notice location of the turn flag bit
    uint256 internal constant TURN_FLAG = 1 << 240;

    /// @notice location of the fighter type bits
    uint256 internal constant FIGHTER_TYPE_BITS = 15 << 241;

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

        // Retrieve the move direction and action for the opponent player from the match data.

        // Get the move hitbox and damage for the current player's move from a mapping.

        // Check if the move hitbox from the current player can hit the opponent player.

        // Update the match data for both players based on the move result.

        // Return the updated match data for both players.
        return (_currentFytherMatchData, _opponentFytherMatchData);
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

    /// @notice Get the energy of the fyter.
    /// @param _matchData The match data.
    /// @return energy The energy of the fyter.
    function getEnergy(uint256 _matchData) internal pure returns (uint256 energy) {
        energy = (_matchData & ENERGY_BITS) >> 168;
    }

    /// @notice Get the x and y coordinates of the fyter.
    /// @param _matchData The match data.
    /// @return x The x coordinate of the fyter.
    /// @return y The y coordinate of the fyter.
    function getCoordinates(uint256 _matchData) internal pure returns (uint256 x, uint256 y) {
        x = (_matchData & X_COORD_BITS) >> 176;
        y = (_matchData & Y_COORD_BITS) >> 192;
    }

    /// @notice Get the direction of the fyter move
    /// @param data The match data.
    /// @return direction The direction of the fyter move.
    function getDirection(uint256 data) internal pure returns (Direction direction) {
        direction = Direction((data & DIRECTION_BITS) >> 208);
    }

    /// @notice Get the action of the fyter move
    /// @param data The match data.
    /// @return action The action of the fyter
    function getAction(uint256 data) internal pure returns (Action action) {
        action = Action((data & ACTION_BITS) >> 212);
    }

    /// @notice Get the round number of the match.
    /// @param _matchData The match data.
    /// @return round The round number of the match.
    function getTime(uint256 _matchData) internal pure returns (uint256 round) {
        round = (_matchData & ROUND_BITS) >> 216;
    }

    /// @notice Get the facing flag of the fyter.
    /// @param _matchData The match data.
    /// @return facing The facing flag of the fyter.
    function getFacing(uint256 _matchData) internal pure returns (uint256 facing) {
        facing = (_matchData & FACING_FLAG) >> 232;
    }

    /// @notice Get the stunned flag of the fyter.
    /// @param _matchData The match data.
    /// @return stunned The stunned flag of the fyter.
    function getStunned(uint256 _matchData) internal pure returns (uint256 stunned) {
        stunned = (_matchData & STUNNED_FLAG) >> 233;
    }

    /// @notice Get the airborne flag of the fyter.
    /// @param _matchData The match data.
    /// @return airborne The airborne flag of the fyter.
    function getAirborne(uint256 _matchData) internal pure returns (uint256 airborne) {
        airborne = (_matchData & AIRBORNE_FLAG) >> 234;
    }

    /// @notice Get the buff of the fyter.
    /// @param _matchData The match data.
    /// @return buff The buff of the fyter.
    function getBuff(uint256 _matchData) internal pure returns (uint256 buff) {
        buff = (_matchData & BUFF_BITS) >> 235;
    }

    /// @notice Get the combo counter of the fyter.
    /// @param _matchData The match data.
    /// @return combo The combo of the fyter.
    function getCombo(uint256 _matchData) internal pure returns (uint256 combo) {
        combo = (_matchData & COMBO_BITS) >> 237;
    }

    /// @notice Get the turn flag of the fyter.
    /// @param _matchData The match data.
    /// @return turn The turn flag of the fyter.
    function getTurn(uint256 _matchData) internal pure returns (uint256 turn) {
        turn = (_matchData & TURN_FLAG) >> 240;
    }
}
