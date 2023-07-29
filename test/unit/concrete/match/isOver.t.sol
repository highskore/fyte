// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Lib

import { Match } from "../../../../src/lib/Match.sol";

// Types

import { Direction, Action } from "../../../../src/types/Types.sol";

// Test

import { Base_Test } from "../../../Base.t.sol";

contract Match_Unit_Concrete_Test is Base_Test {
    using Match for uint256;

    function test_IsOver() public pure {
        uint256 _redPlayerMatchData = 0;
        uint256 _bluePlayerMatchData = 0;
        assert(Match.isOver(_redPlayerMatchData, _bluePlayerMatchData) == true);
    }

    function test_IsOver_RedNotZero() public pure {
        uint256 _redPlayerMatchData = 0;
        uint256 _bluePlayerMatchData = 0;
        _redPlayerMatchData = _redPlayerMatchData.setHp(1);
        assert(Match.isOver(_redPlayerMatchData, _bluePlayerMatchData) == true);
    }

    function test_IsOver_BlueNotZero() public pure {
        uint256 _redPlayerMatchData = 0;
        uint256 _bluePlayerMatchData = 0;
        _bluePlayerMatchData = _bluePlayerMatchData.setHp(1);
        assert(Match.isOver(_redPlayerMatchData, _bluePlayerMatchData) == true);
    }

    function test_IsOver_BothNotZero() public pure {
        uint256 _redPlayerMatchData = 0;
        uint256 _bluePlayerMatchData = 0;
        _redPlayerMatchData = _redPlayerMatchData.setHp(1);
        _bluePlayerMatchData = _bluePlayerMatchData.setHp(1);
        assert(Match.isOver(_redPlayerMatchData, _bluePlayerMatchData) == false);
    }
}
