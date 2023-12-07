// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {IDictionary} from "./IDictionary.sol";
import {DictionaryUtils} from "./DictionaryUtils.sol";

/**
    @title ERC7546: Dictionary Contract
 */
abstract contract DictionaryBase is IDictionary {
    /**
     * @notice Specification 1.2.1
     */
    function getImplementation(bytes4 functionSelector) external view returns (address) {
        address _impl = DictionaryUtils.$Dictionary().implementations[functionSelector];
        if (_impl == address(0)) revert ImplementationNotFound(functionSelector);
        return _impl;
    }

    /**
     * @notice Specification 1.2.2
     */
    function setImplementation(bytes4 functionSelector, address implementation) external {
        _authorizeSetImplementation();

        if (implementation.code.length == 0) {
            revert InvalidImplementation(implementation);
        }

        // In the case of a new functionSelector, add to the functionSelectorList.
        bool _hasSetFunctionSelector;
        bytes4[] memory _functionSelectorList = DictionaryUtils.$Dictionary().functionSelectorList;
        for (uint i; i < _functionSelectorList.length; ++i) {
            if (functionSelector == _functionSelectorList[i]) {
                _hasSetFunctionSelector = true;
            }
        }
        if (!_hasSetFunctionSelector) DictionaryUtils.$Dictionary().functionSelectorList.push(functionSelector);

        // Add the pair of functionSelector and implementation address to the mapping.
        DictionaryUtils.$Dictionary().implementations[functionSelector] = implementation;

        // Notify the change of the mapping.
        emit ImplementationUpgraded(functionSelector, implementation);
    }

    function _authorizeSetImplementation() internal virtual {}

    /**
     * @notice Specification 3.1.1.1
     * @dev The interfaceId equals to the function selector
     */
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return DictionaryUtils.$Dictionary().implementations[interfaceId] != address(0);
    }

    /**
     * @notice Specification 3.1.1.2
     */
    function supportsInterfaces() external view returns (bytes4[] memory) {
        return DictionaryUtils.$Dictionary().functionSelectorList;
    }
}
