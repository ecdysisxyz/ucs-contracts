// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Library version has been tested with version 5.0.0.

import {ERC7546Proxy} from "./ERC7546Proxy.sol";
import {IPredicates} from "../predicates/IPredicates.sol";
import {ERC0000Utils} from "./ERC0000Utils.sol";

/**
 * @title ERC0000: Proxy Contract
 */
contract ERC0000Proxy is ERC7546Proxy {
    constructor(address dictionary, address _predicates, bytes memory _data) payable ERC7546Proxy(dictionary, _data) {
        ERC0000Utils.upgradePredicatesTo(_predicates);
    }

    function _fallback() internal override {
        IPredicates(ERC0000Utils.getPredicates()).beforeOperation();
        _delegate(_implementation());
        IPredicates(ERC0000Utils.getPredicates()).afterOperation();
    }
}
