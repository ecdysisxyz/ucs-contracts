// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract SampleFunction {
    uint256 internal number;

    function setNumber(uint256 newNumber) external {
        number = newNumber;
    }

    function increment() external {
        number++;
    }

    function getNumber() external view returns(uint256) {
        return number;
    }
}
