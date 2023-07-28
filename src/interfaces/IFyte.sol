// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title The interface for {Fyter}

interface IFyte {
    /*//////////////////////////////////////////////////////////////
                               EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a turn is committed.
    event TurnCommited(uint256 fyteID, address player, bytes32 commitment);

    /*//////////////////////////////////////////////////////////////
                               ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice The player is not a valid player for this match.
    error InvalidPlayer();

    /// @notice The commitment does not match the revealed move.
    error InvalidReveal();

    /// @notice The player has already committed.
    error AlreadyCommitted();

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Create a new match for two players. Initializing their positions.
    /// @param _red The address of the red player.
    /// @param _blue The address of the blue player.
    /// @return fyteID The ID of the new match.
    function createMatch(address _red, address _blue) external returns (uint256 fyteID);

    /// @notice Commit a move for the blue player.
    /// @param _fyteID The ID of the match.
    /// @param _commitment The commitment of the move.
    function commitBlueMove(uint256 _fyteID, bytes32 _commitment) external;

    /// @notice Commit a move for the red player.
    /// @param _fyteID The ID of the match.
    /// @param _commitment The commitment of the move.
    function commitRedMove(uint256 _fyteID, bytes32 _commitment) external;

    /// @notice Reveal a move for the blue player.
    /// @param _fyteID The ID of the match.
    /// @param _move The move of the player.
    /// @param _salt The salt of the commitment.
    function revealBlueMove(uint256 _fyteID, uint256 _move, bytes32 _salt) external;

    /// @notice Reveal a move for the red player.
    /// @param _fyteID The ID of the match.
    /// @param _move The move of the player.
    /// @param _salt The salt of the commitment.
    function revealRedMove(uint256 _fyteID, uint256 _move, bytes32 _salt) external;

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Get the data for a match.
    /// @param _fyteID The ID of the match.
    /// @return red The address of the red player.
    /// @return blue The address of the blue player.
    /// @return redData The data of the red player.
    /// @return blueData The data of the blue player.
    function getMatch(uint256 _fyteID)
        external
        view
        returns (address red, address blue, uint256 redData, uint256 blueData);

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                FALLBACK
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                METADATA
    //////////////////////////////////////////////////////////////*/
}
