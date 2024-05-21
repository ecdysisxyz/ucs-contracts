// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IDictionaryCore {
    event NewFunctionSelectorAdded(bytes4 newSelector);
    event ImplementationDeleted(bytes4 selector);
    event ImplementationUpgraded(bytes4 selector, address implementation);

    error ImplementationNotFound(bytes4 selector);
    error InvalidImplementation(address implementation);

    function getImplementation(bytes4 selector) external view returns(address);
}
