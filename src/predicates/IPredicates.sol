// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

interface IPredicates {
    function beforeOperation() external;
    function afterOperation() external;
}
