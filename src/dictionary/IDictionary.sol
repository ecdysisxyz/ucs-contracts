// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @dev Library version has been tested with version 5.0.0.
import {IERC165} from "@oz.ucs/utils/introspection/IERC165.sol";
import {IBeacon as IVerifiable} from "@oz.ucs/proxy/beacon/IBeacon.sol";

interface IDictionary is IVerifiable, IERC165 {
    event ImplementationUpgraded(bytes4 functionSelector, address implementation);
    event FacadeUpgraded(address newFacade);

    error ImplementationNotFound(bytes4 functionSelector);
    error InvalidImplementation(address implementation);

    /**
     * @notice Specification 1.2 & 3
     */
    function getImplementation(bytes4 functionSelector) external view returns (address);
    function setImplementation(bytes4 functionSelector, address implementation) external;
    function supportsInterfaces() external returns (bytes4[] memory);
}
