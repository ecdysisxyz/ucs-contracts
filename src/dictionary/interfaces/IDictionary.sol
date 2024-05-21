// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IDictionaryCore} from "./IDictionaryCore.sol";
import {IVerifiable} from "./IVerifiable.sol";

interface IDictionary is IDictionaryCore, IVerifiable {
    /// @dev from IDictionaryCore
    // event NewFunctionSelectorAdded(bytes4 newSelector);
    // event ImplementationUpgraded(bytes4 selector, address implementation);
    /// @dev from IVerifiable
    // event FacadeUpgraded(address newFacade);

    /// @dev from IDictionaryCore
    // error ImplementationNotFound(bytes4 selector);
    // error InvalidImplementation(address implementation);

    /// @dev from IDictionaryCore
    // function getImplementation(bytes4 selector) external view returns(address);
    /// @dev from IVerifiable
    // function implementation() external view returns(address);
    // function supportsInterface(bytes4 interfaceId) external view returns (bool);
    // function supportsInterfaces() external view returns(bytes4[] memory);
    function setImplementation(bytes4 functionSelector, address implementation) external;
    function upgradeFacade(address newFacade) external;
}
