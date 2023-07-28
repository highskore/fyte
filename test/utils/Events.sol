// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Contracts

import { Owned } from "@solmate/auth/Owned.sol";

// Interfaces

import { IFyte } from "../../src/interfaces/IFyte.sol";

// Types

import { Direction, Action } from "../../src/types/Types.sol";

/// @notice Abstract contract containg all events emitted by all of the Fyte contrancts
abstract contract Events {
    /*//////////////////////////////////////////////////////////////
                                 FYTE
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a match is created.
    event MatchCreated(uint256 fyteID, address red, address blue);

    /// @notice Emitted when a match is liquidated.
    event MatchLiquidated(uint256 fyteID, address winner, uint256 amount);

    /// @notice Emitted when a turn is committed.
    event TurnCommited(uint256 fyteID, address player, bytes32 commitment);

    /// @notice Emitted when a turn is revealed.
    event TurnRevealed(uint256 fyteID, address player, Direction direction, Action action);

    /*//////////////////////////////////////////////////////////////
                                  OWNED
    //////////////////////////////////////////////////////////////*/

    event OwnershipTransferred(address indexed user, address indexed newOwner);
}
