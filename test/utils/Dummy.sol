// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @dev A Dummy Contract for testing
contract DummyContract {}

library Dummy {
    function contractAddress() internal returns(address) {
        return address(new DummyContract());
    }
}
