// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @dev Library version has been tested with version 5.0.0.
import {IERC165} from "@oz.ucs/utils/introspection/IERC165.sol";
import {IBeacon} from "@oz.ucs/proxy/beacon/IBeacon.sol";

interface IVerifiable is IBeacon, IERC165 {
    event FacadeUpgraded(address newFacade);

    /// @dev from IBeacon
    // function implementation() external view returns(address);
    /// @dev from IERC165
    // function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function supportsInterfaces() external view returns(bytes4[] memory);
}
