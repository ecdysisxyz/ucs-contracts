// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import {Helper} from "./utils/Helper.sol";

import {Dictionary} from "../src/Dictionary.sol";

/**
    @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 */
contract DictionaryUnitTest is Test, Dictionary {
    Dictionary internal dictionary = Dictionary(address(this));

    constructor() Dictionary(address(this)) {}

    /**
     *  Dictionary
     *    (1) MUST implement `getImplementation(bytes4 functionSelector)`
     *          to return Function Implementation Contract address.
     *    (2) SHOULD implement `setImplementation(bytes4 functionSelector, address implementation)`
     *      (2-1) to update or add new function selectors and their corresponding Function Implementation Contract addresses to the mapping.
     *      (2-2) and SHOULD be communicated through an event (or log).
     *    (3) is RECOMMENDED to implement
     *      (3-1) `supportsInterface(bytes4 interfaceID)` defined in ERC-165
     *              to indicate which interfaces are supported by the contracts referenced in the mapping.
     *      (3-2) `supportsInterfaces()`
     *              to return a list of registered interfaceIDs
     */

    /// @dev Verify (1)
    function test_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        implementations[_fuzz_functionSelector] = _fuzz_implementation;

        address returnAddress = dictionary.getImplementation(_fuzz_functionSelector);

        assertEq(returnAddress, _fuzz_implementation);
    }

    function test_getImplementation_Invalid_ReturnZeroAddress(bytes4 _fuzz_set_functionSelector, bytes4 _fuzz_request_functionSelector, address _fuzz_implementation) public {
        implementations[_fuzz_set_functionSelector] = _fuzz_implementation;

        vm.assume(_fuzz_request_functionSelector != _fuzz_set_functionSelector);
        address returnAddress = dictionary.getImplementation(_fuzz_request_functionSelector);

        assertEq(returnAddress, address(0));
    }


    function complete_setImplementation(bytes4 functionSelector, address implementation) internal {
        Helper.assertContract(implementation);
        dictionary.setImplementation(functionSelector, implementation);
        assertEq(implementations[functionSelector], implementation);
    }

    /// @dev Verify (2-1)
    function test_setImplementation_Success_SetToMapping(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        complete_setImplementation(_fuzz_functionSelector, _fuzz_implementation);
    }

    /// @dev Verify (2-2)
    function test_setImplementation_Success_EmitEvent(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.expectEmit();
        emit Dictionary.ImplementationUpgraded(_fuzz_functionSelector, _fuzz_implementation);
        complete_setImplementation(_fuzz_functionSelector, _fuzz_implementation);
    }

    function test_setImplementation_Revert_InvalidImplementation_WhenNonContract(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation.code.length == 0);
        vm.expectRevert(abi.encodeWithSelector(Dictionary.InvalidImplementation.selector, _fuzz_implementation));
        dictionary.setImplementation(_fuzz_functionSelector, _fuzz_implementation);
    }

}
