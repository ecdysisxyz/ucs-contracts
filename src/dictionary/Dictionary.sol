// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IDictionary} from "./IDictionary.sol";
import {Ownable} from "@oz.ucs/access/Ownable.sol";


/**
    @title ERC7546: Dictionary Contract
 */
contract Dictionary is IDictionary, Ownable {
    mapping(bytes4 functionSelector => address implementation) internal implementations;
    bytes4[] internal functionSelectorList;
    address public implementation;

    constructor(address owner) Ownable(owner) {}

    function getImplementation(bytes4 functionSelector) public view returns (address) {
        address _impl = implementations[functionSelector];
        if (_impl == address(0)) revert ImplementationNotFound(functionSelector);
        return _impl;
    }

    function setImplementation(bytes4 functionSelector, address implementation_) public onlyOwner {
        if (implementation_.code.length == 0) {
            revert InvalidImplementation(implementation_);
        }

        // In the case of a new functionSelector, add to the functionSelectorList.
        bool _hasSetFunctionSelector;
        bytes4[] memory _functionSelectorList = functionSelectorList;
        for (uint i; i < _functionSelectorList.length; ++i) {
            if (functionSelector == _functionSelectorList[i]) {
                _hasSetFunctionSelector = true;
            }
        }
        if (!_hasSetFunctionSelector) functionSelectorList.push(functionSelector);

        // Add the pair of functionSelector and implementation_ address to the mapping.
        implementations[functionSelector] = implementation_;

        // Notify the change of the mapping.
        emit ImplementationUpgraded(functionSelector, implementation_);
    }


    /**
     * @dev The interfaceId equals to the function selector
     */
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return implementations[interfaceId] != address(0);
    }

    /**
     * @notice Specification 3.1.1.2
     */
    function supportsInterfaces() external view returns (bytes4[] memory) {
        return functionSelectorList;
    }

    // Verifiable
    // function implementation() public view returns (address) {
    //     return implementation;
    // }
    function upgradeFacade(address newFacade) external onlyOwner {
        implementation = newFacade;
        emit FacadeUpgraded(newFacade);
    }

}
