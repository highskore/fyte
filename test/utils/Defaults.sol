// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Types

import { Users } from "./Types.sol";

/// @notice Contract with default values used throughout the tests.
contract Defaults {
    /*//////////////////////////////////////////////////////////////////////////
                                     VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users private users;

    /*//////////////////////////////////////////////////////////////////////////
                                    CONSTRUCTOR
    //////////////////////////////////////////////////////////////////////////*/

    constructor() {
        //
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      HELPERS
    //////////////////////////////////////////////////////////////////////////*/

    function setUsers(Users memory users_) public {
        users = users_;
    }
}
