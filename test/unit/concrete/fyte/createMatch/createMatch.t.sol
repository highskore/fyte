// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Lib

import { Match } from "../../../../../src/lib/Match.sol";

// Contracts

import { Fyte_Unit_Concrete_Test } from "../Fyte.t.sol";

// Types

import { Direction, Action } from "../../../../../src/types/Types.sol";

contract CreateMatch_Concrete_Unit_Test is Fyte_Unit_Concrete_Test {
    using Match for uint256;

    function test_CreateMatch() external {
        // Expect event to be emitted.
        vm.expectEmit();
        emit MatchCreated({ fyteID: 1, red: users.alice, blue: users.bob });

        uint256 fyteID = fyte.createMatch(users.alice, users.bob);

        // Assert the match was created.
        assertEq(fyteID, 1);

        // Assert the match data was correctly initialized
        uint256 blueCorner = fyte.blueCorner(fyteID);
        uint256 redCorner = fyte.redCorner(fyteID);

        // Check the blue corner data
        assertEq(address(uint160(blueCorner)), users.bob);
        (uint256 x, uint256 y) = blueCorner.getCoordinates();
        assertEq(blueCorner.getHp(), 31);
        assertEq(blueCorner.getRound(), 127);
        assertEq(x, 31);
        assertEq(y, 0);
        assertEq(blueCorner.getHitbox(), 0);
        assertEq(blueCorner.getCombo(), 0);
        assert(blueCorner.getDirection() == Direction.NONE);
        assert(blueCorner.getAction() == Action.NONE);

        // Check the red corner data
        assertEq(address(uint160(redCorner)), users.alice);
        (x, y) = redCorner.getCoordinates();
        assertEq(redCorner.getHp(), 31);
        assertEq(redCorner.getRound(), 127);
        assertEq(x, 0);
        assertEq(y, 0);
        assertEq(redCorner.getHitbox(), 0);
        assertEq(redCorner.getCombo(), 0);
        assert(redCorner.getDirection() == Direction.NONE);
        assert(redCorner.getAction() == Action.NONE);
    }

    function test_CreateMatch_Multiple() external {
        // Expect event to be emitted.
        vm.expectEmit();
        emit MatchCreated({ fyteID: 1, red: users.alice, blue: users.bob });

        uint256 fyteID = fyte.createMatch(users.alice, users.bob);

        // Assert the match was created.
        assertEq(fyteID, 1);

        // Expect event to be emitted.
        vm.expectEmit();
        emit MatchCreated({ fyteID: 2, red: users.alice, blue: users.bob });

        fyteID = fyte.createMatch(users.alice, users.bob);

        // Assert the match was created.
        assertEq(fyteID, 2);

        // Expect event to be emitted.
        vm.expectEmit();
        emit MatchCreated({ fyteID: 3, red: users.alice, blue: users.bob });

        fyteID = fyte.createMatch(users.alice, users.bob);

        // Assert the match was created.
        assertEq(fyteID, 3);
    }
}
