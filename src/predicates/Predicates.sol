// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {IPredicates} from "./IPredicates.sol";

contract Predicates is IPredicates {
    function beforeOperation() external {}
    function afterOperation() external {}
}
