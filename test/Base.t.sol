// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Std
import "forge-std/Test.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

// Contracts
import { Fyte } from "../src/Fyte.sol";

// Util
import { Events } from "./utils/Events.sol";
import { Defaults } from "./utils/Defaults.sol";
import { Users } from "./utils/Types.sol";

/// @notice Base test contract with common logic needed by all tests.
abstract contract Base_Test is Events, StdCheats, Defaults, Test {
    /*//////////////////////////////////////////////////////////////////////////
                                    VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    Fyte internal fyte;
    Defaults internal defaults;

    /*//////////////////////////////////////////////////////////////////////////
                                      SET-UPs
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        // Create users for testing.
        users = Users({
            admin: createUser("Admin"),
            alice: createUser("Alice"),
            bob: createUser("Bob"),
            charlie: createUser("Charlie")
        });

        // Deploy the defaults contract.
        defaults = new Defaults();
        defaults.setUsers(users);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      HELPERS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Generates a user, labels its address, and funds it with test assets.
    function createUser(string memory name) internal returns (address payable) {
        address payable user = payable(makeAddr(name));
        vm.deal({ account: user, newBalance: 100 ether });
        return user;
    }

    function deployCore() internal {
        fyte = new Fyte(users.admin);

        vm.label({ account: address(fyte), newLabel: "Fyte" });
    }
}
