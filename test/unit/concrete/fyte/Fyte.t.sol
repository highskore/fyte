// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { Fyte } from "../../../../src/Fyte.sol";

import { Base_Test } from "../../../Base.t.sol";

contract Fyte_Unit_Concrete_Test is Base_Test {
    function setUp() public virtual override {
        Base_Test.setUp();
        deploy();
    }

    function deploy() internal {
        fyte = new Fyte(users.admin);
        vm.label({ account: address(fyte), newLabel: "Fyte" });
    }
}
