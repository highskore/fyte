// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Fyte } from "src/Fyte.sol";

import { Base_Test } from "../../../Base.t.sol";

contract Constructor_Fyte_Unit_Concrete_Test is Base_Test {
    function test_Constructor() external {
        // Expect the relevant event to be emitted.
        vm.expectEmit();
        emit OwnershipTransferred({ user: address(0), newOwner: users.admin });
        // Construct the contract.
        Fyte constructedFyte = new Fyte({ _owner: users.admin });

        // Assert that the admin has been initialized.
        address actualOwner = constructedFyte.owner();
        address expectedOwner = users.admin;
        assertEq(actualOwner, expectedOwner, "admin");
    }
}
