// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Contracts

import { Owned } from "@solmate/auth/Owned.sol";

// Libraries

import { Match } from "./lib/Match.sol";

// Interfaces

import { IFyte } from "./interfaces/IFyte.sol";

// Types

import { Direction, Action } from "./types/Types.sol";

//  ..    ,,                        .c,                         .'ckKo..oo.
// .xKx:'lXX:                ..     '0K:                    .'codkXNk. .dN0c.
// .:dOKKXNN0l;,....        .xKl.    ;KKc              ..;lodoc,.,kx'   ;KKOk:. .;'
//     .';xNNX00OOOOOkkkkkxxo'dK0l.   oNXl. 'c:'.',;cldOXOc'.     .     .xXl:k0dkO,
//        'OW0;....',,,,,,'''  'oKKo' ,KWXo.cXNXOxdol;c0Wo               ,00,.lKX:
//         cXNd.                 .oKXo:kWNNx.,dkl.    .OWo           .....;00; ',
//       ':oKWK;.....              'xXXXN0OXk'        ,KN:        ,oOOOOOOkKWKc.     ..
//      .xKXNNNKkkkko.               ;kXXl.oX0;       :N0'      .d0x;'..';:ld00,    'kl
//        ..:0WXl..                    ,'   cXK:      dWx.     'kO,          ..    .x0'
//           lNWd.      .:looooooollc:;,...  :KXl    .kWo     .oNk'                l0:
//           .kWK;      .cc::ccllodxkO0KKKOxocdXXo.  .ONl      .c0Kd,            .dO;
//            :XWx.                   ..';cox0XNNNo. .kWo         .l0Xkl;'.....':dko.
//            .kWX:                          .,ckXO'  cNO.         .:x0XXK00000xc.
//             'ol.                              ..   .c0c            ..,,,,,'.
//                                                      .'

/// @title Fyte
/// @author highskore
/// @notice A fully on-chain turn-based fighting game.

contract Fyte is IFyte, Owned {
    /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using Match for uint256;

    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice maximum length of a match
    uint256 public constant MAX_MATCH_LENGTH = 10_000;

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public fyteCount;

    /// @notice bitpacked data for a fyter in a match.
    mapping(uint256 fyteID => uint256 fyterData) public blueCorner;
    mapping(uint256 fyteID => uint256 fyterData) public redCorner;

    /// @notice commitment hashes for each fyter in a match.
    mapping(uint256 fyteID => bytes32 commitment) public blueCommitment;
    mapping(uint256 fyteID => bytes32 commitment) public redCommitment;

    /// @notice mapping of fyteID to timestamp of when the match started.
    mapping(uint256 fyteID => uint256 timestamp) public matchStart;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _owner Initial owner of the contract.
    constructor(address _owner) Owned(_owner) {
        // Set _owner as the initial owner of the contract.
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    ///@inheritdoc IFyte
    function createMatch(address _red, address _blue) external override returns (uint256 fyteID) {
        // Initialize the player positions
        redCorner[fyteCount] = uint256(uint160(_red)).initializeRed();
        blueCorner[fyteCount] = uint256(uint160(_blue)).initializeBlue();

        // Set the match start timestamp
        matchStart[fyteCount] = block.timestamp;

        // Increment the fyte count
        return ++fyteCount;
    }

    ///@inheritdoc IFyte
    function commitBlueMove(uint256 _fyteID, bytes32 _commitment) external {
        address player = msg.sender;

        // Check if it's the blue player's turn to commit and if the message sender is the blue player
        uint256 bluePlayerData = blueCorner[_fyteID];
        if (player != address(uint160(bluePlayerData)) || bluePlayerData.getTurn() != 0) {
            revert InvalidTurn();
        }

        // Check if the commitment is empty
        if (blueCommitment[_fyteID] != 0) {
            revert AlreadyCommitted();
        }

        // Store the commitment
        blueCommitment[_fyteID] = _commitment;
        emit TurnCommited(_fyteID, player, _commitment);
    }

    ///@inheritdoc IFyte
    function commitRedMove(uint256 _fyteID, bytes32 _commitment) external {
        address player = msg.sender;

        // Check if it's the red player's turn to commit and if the message sender is the red player
        uint256 redPlayerData = redCorner[_fyteID];
        if (player != address(uint160(redPlayerData)) || redPlayerData.getTurn() != 1) {
            revert InvalidTurn();
        }

        // Check if the commitment is empty
        if (redCommitment[_fyteID] != 0) {
            revert AlreadyCommitted();
        }

        // Store the commitment
        redCommitment[_fyteID] = _commitment;
        emit TurnCommited(_fyteID, player, _commitment);
    }

    ///@inheritdoc IFyte
    function revealBlueMove(uint256 _fyteID, Direction _direction, Action _action, bytes32 _salt) external {
        address player = msg.sender;

        // Check if it's the blue player's turn to reveal and if the message sender is the blue player
        uint256 bluePlayerData = blueCorner[_fyteID];
        // Check if the round count is even or odd to determine if it's the blue player's turn to reveal
        uint256 round = bluePlayerData.getRound() & 0x1;
        if (
            player != address(uint160(bluePlayerData)) || (round == 0 && bluePlayerData.getTurn() != 2)
                || (round == 1 && bluePlayerData.getTurn() != 3)
        ) {
            revert InvalidTurn();
        }

        // Check if the hashed move matches the commitment
        bytes32 hashedMove = keccak256(abi.encodePacked(_direction, _action, _salt));
        if (hashedMove != blueCommitment[_fyteID]) {
            revert InvalidReveal();
        }

        blueCorner[_fyteID] = bluePlayerData.setDirection(_direction).setAction(_action);
        if (round == 1) {
            // Execute the round
            (blueCorner[_fyteID], redCorner[_fyteID]) = blueCorner[_fyteID].executeRound(redCorner[_fyteID]);
            delete blueCommitment[_fyteID];
            delete redCommitment[_fyteID];
        }

        emit TurnRevealed(_fyteID, player, _direction, _action);
    }

    ///@inheritdoc IFyte
    function revealRedMove(uint256 _fyteID, Direction _direction, Action _action, bytes32 _salt) external {
        address player = msg.sender;

        // Check if it's the red player's turn to reveal and if the message sender is the red player
        uint256 redPlayerData = redCorner[_fyteID];
        // Check if the round count is even or odd to determine if it's the red player's turn to reveal
        uint256 round = redPlayerData.getRound() & 0x01;
        if (
            player != address(uint160(redPlayerData)) || (round == 1 && redPlayerData.getTurn() != 2)
                || (round == 0 && redPlayerData.getTurn() != 3)
        ) {
            revert InvalidTurn();
        }

        // Check if the hashed move matches the commitment
        bytes32 hashedMove = keccak256(abi.encodePacked(_direction, _action, _salt));
        if (hashedMove != redCommitment[_fyteID]) {
            revert InvalidReveal();
        }

        redCorner[_fyteID] = redPlayerData.setDirection(_direction).setAction(_action);
        if (round == 0) {
            // Execute the round
            (redCorner[_fyteID], blueCorner[_fyteID]) = redCorner[_fyteID].executeRound(blueCorner[_fyteID]);
            delete blueCommitment[_fyteID];
            delete redCommitment[_fyteID];
        }
        emit TurnRevealed(_fyteID, player, _direction, _action);
    }

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    ///@inheritdoc IFyte
    function getMatch(uint256 _fyteID)
        public
        view
        returns (address red, address blue, uint256 redData, uint256 blueData)
    {
        uint256 _red = redCorner[_fyteID];
        uint256 _blue = blueCorner[_fyteID];

        red = address(uint160(_red));
        blue = address(uint160(_blue));

        redData = _red << 160;
        blueData = _blue << 160;
    }

    ///@inheritdoc IFyte
    function liquidate(uint256 _fyteID) public {
        //
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                METADATA
    //////////////////////////////////////////////////////////////*/
}
