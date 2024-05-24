// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {Helper} from "test/utils/Helper.sol";
import {Dummy} from "test/utils/Dummy.sol";

import {DictionaryBase} from "src/dictionary/base/DictionaryBase.sol";

/**
 *  @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 *
 *  Dictionary Specs
 *    (1) getImplementation(bytes4 selector)
 *          MUST return Function Implementation Contract address.
 *    (2) supportsInterface(bytes4 interfaceID) defined in ERC-165
 *          is RECOMMENDED to indicate which interfaces are supported by the contracts referenced in the mapping.
 *    (3) supportsInterfaces()
 *          is RECOMMENDED to return a list of registered interfaceIDs
 *    (4) implementation()
 */
contract DictionaryBaseTest is Test, DictionaryBase {
    DictionaryBase internal dictionary = DictionaryBase(address(this));

    /**--------------------------
        (1) getImplementation
    ----------------------------*/
    //  (1) Happy Path
    function test_1_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        functions[_fuzz_selector] = _fuzz_implementation;

        address returnAddress = dictionary.getImplementation(_fuzz_selector);

        assertEq(returnAddress, _fuzz_implementation);
    }

    function test_1_getImplementation_Success_ReturnFallbackAddress(address _fuzz_implementation, bytes4 _fuzz_request_selector) public {
        vm.assume(_fuzz_implementation != address(0));
        functions[bytes4(0)] = _fuzz_implementation;

        address returnAddress = dictionary.getImplementation(_fuzz_request_selector);

        assertEq(returnAddress, _fuzz_implementation);
    }

    //  (1) Revert
    function test_1_getImplementation_Revert_ImplementationNotFound_WhenRequestDifferentSelector(bytes4 _fuzz_set_selector, bytes4 _fuzz_request_selector, address _fuzz_implementation) public {
        /// @dev Assume no fallback
        vm.assume(_fuzz_set_selector != bytes4(0));
        functions[_fuzz_set_selector] = _fuzz_implementation;

        vm.assume(_fuzz_request_selector != _fuzz_set_selector);
        vm.expectRevert(abi.encodeWithSelector(ImplementationNotFound.selector, _fuzz_request_selector));
        dictionary.getImplementation(_fuzz_request_selector);
    }


    /**---------------------------
        (2) supportsInterface
    -----------------------------*/
    //  (2) Happy Path
    function test_2_supportsInterface_Success_ReturnTrue(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        functions[_fuzz_selector] = _fuzz_implementation;
        assertTrue(dictionary.supportsInterface(_fuzz_selector));
    }

    //  (2) Invalid
    function test_2_supportsInterface_Invalid_ReturnFalse_WhenNotSet(bytes4 _fuzz_selector) public {
        assertFalse(dictionary.supportsInterface(_fuzz_selector));
    }


    /**---------------------------
        (3) supportsInterfaces
    -----------------------------*/
    //  (3) Happy Path
    function test_3_supportsInterfaces_Success_ReturnCorrectSelectors(bytes4[] calldata _fuzz_selectors) public {
        Helper.assumeUnique(_fuzz_selectors);
        for (uint i; i < _fuzz_selectors.length; ++i) {
            functionSelectorList.push(_fuzz_selectors[i]);
        }

        bytes4[] memory interfaces = dictionary.supportsInterfaces();

        assertEq(
            keccak256(abi.encodePacked(_fuzz_selectors)),
            keccak256(abi.encodePacked(interfaces))
        );
    }

    //  (3) Invalid
    function test_3_supportsInterfaces_Invalid_ReturnUnexpectedSelectors(bytes4[4] memory _fuzz_inputSelectors, bytes4[4] memory _fuzz_expectedSelectors) public {
        for (uint i; i < _fuzz_inputSelectors.length; ++i) {
            functionSelectorList.push(_fuzz_inputSelectors[i]);
        }

        vm.assume(
            keccak256(abi.encodePacked(_fuzz_inputSelectors)) !=
            keccak256(abi.encodePacked(_fuzz_expectedSelectors))
        );

        bytes4[] memory interfaces = dictionary.supportsInterfaces();

        assertNotEq(
            keccak256(abi.encodePacked(_fuzz_expectedSelectors)),
            keccak256(abi.encodePacked(interfaces))
        );
    }


    /**------------------------
        (4) implementation
    --------------------------*/
    //  (4) Happy Path
    function test_4_implementation_Success_ReturnCorrectFacade(address _fuzz_facade) public {
        assertEq(dictionary.implementation(), address(0));
        facade = _fuzz_facade;
        address _retImpl = dictionary.implementation();
        assertEq(facade, _retImpl);
        assertEq(facade, _fuzz_facade);
    }

}
