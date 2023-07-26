// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Contracts

import { ERC721 } from "@solmate/tokens/ERC721.sol";
import { Owned } from "@solmate/auth/Owned.sol";

// Libraries

import { Base64 } from "../lib/Base64.sol";

// Interfaces

import { IFyter } from "../interfaces/IFyter.sol";

/// @title Fyter

contract Fyter is IFyter, ERC721, Owned {
    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Description of the collection.
    string public constant COLLECTION_DESCRIPTION = unicode"1v1 me bro";

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _owner Initial owner of the contract.
    constructor(address _owner) ERC721("Fyter", "FYT") Owned(_owner) {
        // Set _owner as the initial owner of the contract.
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mint(uint256 _id) external {
        // Mint token.
        _mint(msg.sender, _id);
    }

    /*//////////////////////////////////////////////////////////////
                                METADATA
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // TODO
    }

    function contractURI() external pure override returns (string memory) {
        return string.concat(
            "data:application/json;base64,",
            Base64.encode(abi.encodePacked('{"name":"Fyter","description":"', COLLECTION_DESCRIPTION, '"}'))
        );
    }
}
