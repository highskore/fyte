// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
