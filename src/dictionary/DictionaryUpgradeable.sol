// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {IDictionary} from "./IDictionary.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract DictionaryUpgradeable is IDictionary {
    /// @custom:storage-location erc7201:ucs.storage.Dictionary
    struct DictionaryStorage {
        mapping(bytes4 functionSelector => address implementation) implementations;
        address admin;
        bytes4[] functionSelectorList;
    }

    bytes32 internal constant DICTIONARY_STORAGE_LOCATION = 0xf14ccab36e70fe6703d70047fd9f791010c6456c7ac5d1945a4518f360bd1fe3;

    function $Dictionary() internal pure returns (DictionaryStorage storage $) {
        assembly {
            $.slot := DICTIONARY_STORAGE_LOCATION
        }
    }

    constructor(address admin) {
        _setAdmin(admin);
    }

    modifier onlyAdmin() {
        if (msg.sender != $Dictionary().admin) revert InvalidAccess(msg.sender);
        _;
    }

    /**
     * @notice Specification 1.2.1
     */
    function getImplementation(bytes4 functionSelector) external view returns (address) {
        address _impl = $Dictionary().implementations[functionSelector];
        if (_impl == address(0)) revert ImplementationNotFound(functionSelector);
        return _impl;
    }

    /**
     * @notice Specification 1.2.2
     */
    function setImplementation(bytes4 functionSelector, address implementation) external onlyAdmin {
        if (implementation.code.length == 0) {
            revert InvalidImplementation(implementation);
        }

        // In the case of a new functionSelector, add to the functionSelectorList.
        bool _hasSetFunctionSelector;
        bytes4[] memory _functionSelectorList = $Dictionary().functionSelectorList;
        for (uint i; i < _functionSelectorList.length; ++i) {
            if (functionSelector == _functionSelectorList[i]) {
                _hasSetFunctionSelector = true;
            }
        }
        if (!_hasSetFunctionSelector) $Dictionary().functionSelectorList.push(functionSelector);

        // Add the pair of functionSelector and implementation address to the mapping.
        $Dictionary().implementations[functionSelector] = implementation;

        // Notify the change of the mapping.
        emit ImplementationUpgraded(functionSelector, implementation);
    }

    /**
     * @notice Specification 3.1.1.1
     * @dev The interfaceId equals to the function selector
     */
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return $Dictionary().implementations[interfaceId] != address(0);
    }

    /**
     * @notice Specification 3.1.1.2
     */
    function supportsInterfaces() external view returns (bytes4[] memory) {
        return $Dictionary().functionSelectorList;
    }

    function _setAdmin(address newAdmin) private {
        address _prevAdmin = $Dictionary().admin;

        $Dictionary().admin = newAdmin;

        emit AdminChanged(_prevAdmin, newAdmin);
    }
}
