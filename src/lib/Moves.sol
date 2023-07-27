// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Moves

library Moves {
    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/

    /// @notice Enumeration for defining movement directions.
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

    /// @notice Enumeration for defining action moves.
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

    /// @notice damage values for each action
    uint256 public constant NO_DAMAGE = 0x0;
    uint256 public constant LOW_DAMAGE = 0x1;
    uint256 public constant MED_DAMAGE = 0x2;
    uint256 public constant HIGH_DAMAGE = 0x3;

    /// @notice Grid representing NONE direction with single actions.
    uint256 public constant NONE_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | NO_DAMAGE << 147) // LH
        | (0x0 << 100 | NO_DAMAGE << 98) // RH
        | (0x0 << 51 | NO_DAMAGE << 49) // LL
        | (0x0 << 2 | NO_DAMAGE << 0); // RL

    /// @notice Grid representing NONE direction with multiple actions.
    uint256 public constant NONE_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | NO_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | NO_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | NO_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | NO_DAMAGE << 0); // RH_RL

    /// @notice Grid representing UP_LEFT direction with single actions.
    uint256 public constant UP_LEFT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing UP_LEFT direction with multiple actions.
    uint256 public constant UP_LEFT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing UP direction with single actions.
    uint256 public constant UP_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing UP direction with multiple actions.
    uint256 public constant UP_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing UP_RIGHT direction with single actions.
    uint256 public constant UP_RIGHT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing UP_RIGHT direction with multiple actions.
    uint256 public constant UP_RIGHT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing MIDDLE_LEFT direction with single actions.
    uint256 public constant MIDDLE_LEFT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing MIDDLE_LEFT direction with multiple actions.
    uint256 public constant MIDDLE_LEFT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing MIDDLE direction with single actions.
    uint256 public constant MIDDLE_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing MIDDLE direction with multiple actions.
    uint256 public constant MIDDLE_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing MIDDLE_RIGHT direction with single actions.
    uint256 public constant MIDDLE_RIGHT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing MIDDLE_RIGHT direction with multiple actions.
    uint256 public constant MIDDLE_RIGHT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing BOTTOM_LEFT direction with single actions.
    uint256 public constant BOTTOM_LEFT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing BOTTOM_LEFT direction with multiple actions.
    uint256 public constant BOTTOM_LEFT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing BOTTOM direction with single actions.
    uint256 public constant BOTTOM_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing BOTTOM direction with multiple actions.
    uint256 public constant BOTTOM_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Grid representing BOTTOM_RIGHT direction with single actions.
    uint256 public constant BOTTOM_RIGHT_SINGLE_ACTIONS_GRID = (0x0 << 198 | NO_DAMAGE << 196) // NONE
        | (0x0 << 149 | LOW_DAMAGE << 147) // LH
        | (0x0 << 100 | LOW_DAMAGE << 98) // RH
        | (0x0 << 51 | HIGH_DAMAGE << 49) // LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RL

    /// @notice Grid representing BOTTOM_RIGHT direction with multiple actions.
    uint256 public constant BOTTOM_RIGHT_MULTIPLE_ACTIONS_GRID = (0x0 << 198 | LOW_DAMAGE << 196) // LH_RH
        | (0x0 << 149 | MED_DAMAGE << 147) // LH_LL
        | (0x0 << 100 | MED_DAMAGE << 98) // LH_RL
        | (0x0 << 51 | HIGH_DAMAGE << 49) // RH_LL
        | (0x0 << 2 | HIGH_DAMAGE << 0); // RH_RL

    /// @notice Retrieves the sprite grid for a given direction and action.
    /// @param direction The direction of the sprite.
    /// @param action The action of the sprite.
    /// @return grid The sprite grid.
    function getSpriteGrid(Direction direction, Action action) public pure returns (uint256 grid, uint256 damage) {
        uint256 grids;

        if (uint8(action) <= 4) {
            // Single action
            grids = getSingleActionGrids(direction);
        } else {
            // Multiple action
            grids = getMultipleActionGrids(direction);
        }

        return extractGridAndDamageByIndex(grids, uint8(action) % 5);
    }

    /// @notice Retrieves the sprite grids for single actions for a given direction.
    /// @param direction The direction of the sprite.
    /// @return grids The sprite grids for single actions.
    function getSingleActionGrids(Direction direction) public pure returns (uint256 grids) {
        if (direction == Direction.NONE) return NONE_SINGLE_ACTIONS_GRID;
        if (direction == Direction.UP_LEFT) return UP_LEFT_SINGLE_ACTIONS_GRID;
        if (direction == Direction.UP) return UP_SINGLE_ACTIONS_GRID;
        if (direction == Direction.UP_RIGHT) return UP_RIGHT_SINGLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE_LEFT) return MIDDLE_LEFT_SINGLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE) return MIDDLE_SINGLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE_RIGHT) return MIDDLE_RIGHT_SINGLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM_LEFT) return BOTTOM_LEFT_SINGLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM) return BOTTOM_SINGLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM_RIGHT) return BOTTOM_RIGHT_SINGLE_ACTIONS_GRID;
    }

    /// @notice Retrieves the sprite grids for multiple actions for a given direction.
    /// @param direction The direction of the sprite.
    /// @return grids The sprite grids for multiple actions.
    function getMultipleActionGrids(Direction direction) public pure returns (uint256 grids) {
        if (direction == Direction.NONE) return NONE_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.UP_LEFT) return UP_LEFT_MULTIPLE_ACTIONS_GRID; // Added
        if (direction == Direction.UP) return UP_MULTIPLE_ACTIONS_GRID; // Added
        if (direction == Direction.UP_RIGHT) return UP_RIGHT_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE_LEFT) return MIDDLE_LEFT_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE) return MIDDLE_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.MIDDLE_RIGHT) return MIDDLE_RIGHT_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM_LEFT) return BOTTOM_LEFT_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM) return BOTTOM_MULTIPLE_ACTIONS_GRID;
        if (direction == Direction.BOTTOM_RIGHT) return BOTTOM_RIGHT_MULTIPLE_ACTIONS_GRID; // Added
    }

    /// @notice Extracts the grid bits and damage bits by index from a set of sprite grids.
    /// @param grids The set of sprite grids.
    /// @param index The index of the grid to extract.
    /// @return grid The extracted sprite grid.
    /// @return damage The extracted damage value.
    function extractGridAndDamageByIndex(
        uint256 grids,
        uint8 index
    )
        internal
        pure
        returns (uint256 grid, uint256 damage)
    {
        uint256 gridAndDamage = (grids >> (index * 51)) & ((1 << 51) - 1);
        grid = gridAndDamage >> 2; // Extract grid bits (49 bits)
        damage = gridAndDamage & 0x3; // Extract damage bits (2 bits)
    }
}
