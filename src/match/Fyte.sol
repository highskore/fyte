// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Contracts

import { Owned } from "@solmate/auth/Owned.sol";

// Libraries

import { Match } from "../lib/Match.sol";

// Interfaces

import { IFyte } from "../interfaces/IFyte.sol";

//  ..    ,,                        .c,                         .'ckKo..oo.
// .xKx:'lXX:                ..     '0K:                    .'codkXNk. .dN0c.
// .:dOKKXNN0l;,....        .xKl.    ;KKc              ..;lodoc,.,kx'   ;KKOk:. .;'
//     .';xNNX00OOOOOkkkkkxxo'dK0l.   oNXl. 'c:'.',;cldOXOc'.     .     .xXl:k0dkO,
//        'OW0;....',,,,,,'''  'oKKo' ,KWXo.cXNXOxdol;c0Wo               ,00,.lKX:
//         cXNd.                 .oKXo:kWNNx.,dkl.    .OWo           .....;00; ',
//       ':oKWK;.....              'xXXXN0OXk'        ,KN:        ,oOOOOOOkKWKc.     ..
//      .xKXNNNKkkkko.               ;kXXl.oX0;       :N0'      .d0x;'..';:ld00,    'kl
//        ..:0WXl..                    ,'   cXK:      dWx.     'kO,          ..    .x0'
//           lNWd.      .:looooooollc:;,...  :KXl    .kWo     .oNk'                l0:
//           .kWK;      .cc::ccllodxkO0KKKOxocdXXo.  .ONl      .c0Kd,            .dO;
//            :XWx.                   ..';cox0XNNNo. .kWo         .l0Xkl;'.....':dko.
//            .kWX:                          .,ckXO'  cNO.         .:x0XXK00000xc.
//             'ol.                              ..   .c0c            ..,,,,,'.
//                                                      .'

/// @title Fyte
/// @author highskore
/// @notice A fully on-chain turn-based fighting game.

contract Fyte is IFyte, Owned {
    /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

    using Match for uint256;

    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice maximum length of a match
    uint256 public constant MAX_MATCH_LENGTH = 10_000;

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public fyteCount;

    /// @notice bitpacked data for a fyter in a match.
    mapping(uint256 fyteID => uint256 fyterData) public blueCorner;
    mapping(uint256 fyteID => uint256 fyterData) public redCorner;

    /// @notice mapping of fyteID to timestamp of when the match started.
    mapping(uint256 fyteID => uint256 timestamp) public matchStart;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _owner Initial owner of the contract.
    constructor(address _owner) Owned(_owner) {
        // Set _owner as the initial owner of the contract.
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNAL
    //////////////////////////////////////////////////////////////*/

    ///@inheritdoc IFyte
    function createMatch(address _red, address _blue) external override returns (uint256 fyteID) {
        redCorner[fyteCount] = uint256(uint160(_red));
        blueCorner[fyteCount] = uint256(uint160(_blue));

        return ++fyteCount;
    }

    /*//////////////////////////////////////////////////////////////
                                PUBLIC
    //////////////////////////////////////////////////////////////*/

    ///@inheritdoc IFyte
    function getMatch(uint256 _fyteID)
        public
        view
        returns (address red, address blue, uint256 redData, uint256 blueData)
    {
        uint256 _red = redCorner[_fyteID];
        uint256 _blue = blueCorner[_fyteID];

        red = address(uint160(_red));
        blue = address(uint160(_blue));

        redData = _red << 160;
        blueData = _blue << 160;
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PRIVATE
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                METADATA
    //////////////////////////////////////////////////////////////*/
}
