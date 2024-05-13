// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Helper} from "./utils/Helper.sol";
import {Dummy} from "./utils/Dummy.sol";

import {ImmutableDictionary, Function} from "../src/dictionary/extensions/ImmutableDictionary.sol";

/**
 *  @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 *
 *  Dictionary Specs
 *    (1) getImplementation(bytes4 functionSelector)
 *          MUST return Function Implementation Contract address.
 *    (2) setImplementation(bytes4 functionSelector, address implementation)
 *      (2-1) SHOULD add new function selectors and their corresponding Function Implementation Contract addresses to the mapping.
 *      (2-2) SHOULD update
 *      (2-3) SHOULD be communicated through an event (or log).
 *    (3) supportsInterface(bytes4 interfaceID) defined in ERC-165
 *          is RECOMMENDED to indicate which interfaces are supported by the contracts referenced in the mapping.
 *    (4) supportsInterfaces()
 *          is RECOMMENDED to return a list of registered interfaceIDs
 */
contract ImmutableDictionaryTest is Test, ImmutableDictionary {
    ImmutableDictionary internal dictionary = ImmutableDictionary(address(this));
    Function[] funcs;
    constructor() ImmutableDictionary(funcs, address(new Dummy())) {}


    /**--------------------------
        (1) getImplementation
    ----------------------------*/
    //  (1) Positive
    function test_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        implementations[_fuzz_functionSelector] = _fuzz_implementation;

        address returnAddress = dictionary.getImplementation(_fuzz_functionSelector);

        assertEq(returnAddress, _fuzz_implementation);
    }

    //  (1) Negative
    function test_getImplementation_Revert_ImplementationNotFound_WhenRequestDifferentSelector(bytes4 _fuzz_set_functionSelector, bytes4 _fuzz_request_functionSelector, address _fuzz_implementation) public {
        implementations[_fuzz_set_functionSelector] = _fuzz_implementation;

        vm.assume(_fuzz_request_functionSelector != _fuzz_set_functionSelector);
        vm.expectRevert(abi.encodeWithSelector(ImmutableDictionary.ImplementationNotFound.selector, _fuzz_request_functionSelector));
        address returnAddress = dictionary.getImplementation(_fuzz_request_functionSelector);

        assertEq(returnAddress, address(0));
    }


    /**--------------------------
        (3) supportsInterface
    ----------------------------*/
    //  (3) Positive
    function test_supportsInterface_Success_ReturnTrue(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        implementations[_fuzz_functionSelector] = _fuzz_implementation;
        assertTrue(dictionary.supportsInterface(_fuzz_functionSelector));
    }

    //  (3) Negative
    function test_supportsInterface_Invalid_ReturnFalse_WhenNotSet(bytes4 _fuzz_functionSelector) public {
        assertFalse(dictionary.supportsInterface(_fuzz_functionSelector));
    }


    /**---------------------------
        (4) supportsInterfaces
    -----------------------------*/
    // (4) Positive
    function test_supportsInterfaces_Success_ReturnCorrectSelectors(bytes4[] calldata _fuzz_functionSelectors) public {
        Helper.assumeUnique(_fuzz_functionSelectors);
        for (uint i; i < _fuzz_functionSelectors.length; ++i) {
            functionSelectorList.push(_fuzz_functionSelectors[i]);
        }

        bytes4[] memory interfaces = dictionary.supportsInterfaces();

        assertEq(
            keccak256(abi.encodePacked(_fuzz_functionSelectors)),
            keccak256(abi.encodePacked(interfaces))
        );
    }

    // (4) Negative
    function test_supportsInterfaces_Invalid_ReturnUnexpectedSelectors(bytes4 _fuzz_inputSelector, bytes4 _fuzz_expectedSelector) public {
        functionSelectorList.push(_fuzz_inputSelector);

        vm.assume(_fuzz_inputSelector != _fuzz_expectedSelector);

        bytes4[] memory interfaces = dictionary.supportsInterfaces();
        bytes4[] memory expectedInterfaces = new bytes4[](1);
        expectedInterfaces[0] = _fuzz_expectedSelector;

        assertNotEq(
            keccak256(abi.encodePacked(expectedInterfaces)),
            keccak256(abi.encodePacked(interfaces))
        );
    }
}
