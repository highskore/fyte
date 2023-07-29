// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Lib

import { Match } from "../../../../src/lib/Match.sol";

// Types

import { Direction, Action } from "../../../../src/types/Types.sol";

// Test

import { Base_Test } from "../../../Base.t.sol";

contract Match_Fuzz_Test is Base_Test {
    using Match for uint256;

    function testFuzz_Hp(uint256 _matchData, uint8 _hp) public pure {
        vm.assume(_hp < 32);
        uint256 updatedMatchData = _matchData.setHp(_hp);
        assert(updatedMatchData.getHp() == _hp);
    }

    function TestFuzz_Round(uint256 _matchData, uint8 _round) public pure {
        vm.assume(_round < 127);
        uint256 updatedMatchData = _matchData.setRound(_round);
        assert(updatedMatchData.getRound() == _round);
    }

    function testFuzz_X(uint256 _matchData, uint8 _x) public pure {
        vm.assume(_x < 32);
        uint256 updatedMatchData = _matchData.setX(_x);
        (uint256 x,) = updatedMatchData.getCoordinates();
        assert(x == _x);
    }

    function testFuzz_Y(uint256 _matchData, uint8 _y) public pure {
        vm.assume(_y < 16);
        uint256 updatedMatchData = _matchData.setY(_y);
        (, uint256 y) = updatedMatchData.getCoordinates();
        assert(y == _y);
    }

    function testFuzz_Direction(uint256 _matchData, uint8 _direction) public pure {
        vm.assume(uint256(_direction) < 10);
        uint256 updatedMatchData = _matchData.setDirection(Direction(_direction));
        assert(updatedMatchData.getDirection() == Direction(_direction));
    }

    function testFuzz_Action(uint256 _matchData, uint8 _action) public pure {
        vm.assume(uint256(_action) < 10);
        uint256 updatedMatchData = _matchData.setAction(Action(_action));
        assert(updatedMatchData.getAction() == Action(_action));
    }

    function testFuzz_Hitbox(uint256 _matchData, uint8 _hitbox) public pure {
        vm.assume(_hitbox < 64);
        uint256 updatedMatchData = _matchData.setHitbox(_hitbox);
        assert(updatedMatchData.getHitbox() == _hitbox);
    }

    function testFuzz_Combo(uint256 _matchData, uint8 _combo) public pure {
        vm.assume(_combo < 2);
        uint256 updatedMatchData = _matchData.setCombo(_combo);
        assert(updatedMatchData.getCombo() == _combo);
    }

    function testFuzz_Turn(uint256 _matchData, uint8 _turn) public pure {
        vm.assume(_turn < 4);
        uint256 updatedMatchData = _matchData.setTurn(_turn);
        assert(updatedMatchData.getTurn() == _turn);
    }

    function testFuzz_InitializeRed(address redPlayer) public pure {
        uint256 matchData = uint256(uint160(address(redPlayer)));
        matchData = matchData.initializeRed();
        (uint256 x, uint256 y) = matchData.getCoordinates();
        assert(matchData.getHp() == 31);
        assert(matchData.getRound() == 127);
        assert(x == 0);
        assert(y == 0);
        assert(matchData.getDirection() == Direction.NONE);
        assert(matchData.getAction() == Action.NONE);
        assert(matchData.getHitbox() == 0);
        assert(matchData.getCombo() == 0);
        assert(matchData.getTurn() == 0);
    }

    function testFuzz_InitializeBlue(address bluePlayer) public pure {
        uint256 matchData = uint256(uint160(address(bluePlayer)));
        matchData = matchData.initializeBlue();
        (uint256 x, uint256 y) = matchData.getCoordinates();
        assert(matchData.getHp() == 31);
        assert(matchData.getRound() == 127);
        assert(x == 31);
        assert(y == 0);
        assert(matchData.getDirection() == Direction.NONE);
        assert(matchData.getAction() == Action.NONE);
        assert(matchData.getHitbox() == 0);
        assert(matchData.getCombo() == 0);
        assert(matchData.getTurn() == 0);
    }
}
