// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {Helper, UCSFunction} from "test/utils/Helper.sol";
import {Dummy} from "test/utils/Dummy.sol";

import {Dictionary} from "src/dictionary/Dictionary.sol";
import {Ownable} from "@oz.ucs/access/Ownable.sol";

/**
 *  @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 *
 *  Dictionary Specs
 *    (1) setImplementation(bytes4 selector, address implementation)
 *    (2) upgradeFacade(address newFacade)
 */
contract DictionaryTest is Test, Dictionary {
    Dictionary internal dictionary = Dictionary(address(this));
    constructor() Dictionary(address(this)) {} /// @dev Set this test contract address as the owner

    /**-----------------
        Integration
    -------------------*/
    function test_Dictionary_Success(UCSFunction[5] memory _fuzz_functions, address _fuzz_facade) public {
        for (uint i; i < _fuzz_functions.length; ++i) {
            bytes4 _selector = _fuzz_functions[i].selector;
            address _impl = _fuzz_functions[i].implementation;
            Helper.assertContract(_impl);
            dictionary.setImplementation(_selector, _impl);
            address _retImpl = dictionary.getImplementation(_selector);
            assertEq(_impl, _retImpl);
            assertTrue(dictionary.supportsInterface(_selector));
        }
        bytes4[] memory _interfaces = dictionary.supportsInterfaces();
        for (uint i; i < _interfaces.length; ++i) {
            assertTrue(dictionary.supportsInterface(_interfaces[i]));
            assertTrue(dictionary.getImplementation(_interfaces[i]).code.length > 0);
        }
        Helper.assertContract(_fuzz_facade);
        dictionary.upgradeFacade(_fuzz_facade);
        assertEq(dictionary.implementation(), _fuzz_facade);
    }


    /**--------------------------
        (1) setImplementation
    ----------------------------*/
    function _execute_setImplementation_WithContractAddr(bytes4 _selector, address _implementation) internal {
        Helper.assertContract(_implementation);
        dictionary.setImplementation(_selector, _implementation);
    }

    //  (1) Happy Path
    function test_1_setImplementation_Success_AddToMapping(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        vm.expectEmit();
        emit NewFunctionSelectorAdded(_fuzz_selector);
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_implementation);
        assertEq(functions[_fuzz_selector], _fuzz_implementation);
        assertEq(functionSelectorList.length, 1);
        assertEq(functionSelectorList[0], _fuzz_selector);
    }

    function test_1_setImplementation_Success_UpdateFunction(bytes4 _fuzz_selector, address _fuzz_implementation, address _fuzz_newImplementation) public {
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_implementation);
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_newImplementation);
        assertEq(functions[_fuzz_selector], _fuzz_newImplementation);
        assertEq(functionSelectorList.length, 1);
        assertEq(functionSelectorList[0], _fuzz_selector);
    }

    function test_1_setImplementation_Success_AddNewFunction(bytes4 _fuzz_selector, bytes4 _fuzz_newSelector, address _fuzz_implementation) public {
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_implementation);
        vm.assume(_fuzz_selector != _fuzz_newSelector);
        vm.expectEmit();
        emit NewFunctionSelectorAdded(_fuzz_newSelector);
        _execute_setImplementation_WithContractAddr(_fuzz_newSelector, _fuzz_implementation);
        assertEq(functions[_fuzz_selector], _fuzz_implementation);
        assertEq(functions[_fuzz_newSelector], _fuzz_implementation);
        assertEq(functionSelectorList.length, 2);
        assertEq(functionSelectorList[0], _fuzz_selector);
        assertEq(functionSelectorList[1], _fuzz_newSelector);
    }

    function test_1_setImplementation_Success_DeleteFunction(bytes4 _fuzz_selector, bytes4 _fuzz_newSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_selector != _fuzz_newSelector);
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_implementation);
        _execute_setImplementation_WithContractAddr(_fuzz_newSelector, _fuzz_implementation);

        vm.expectEmit();
        emit ImplementationDeleted(_fuzz_selector);
        dictionary.setImplementation(_fuzz_selector, address(0));
        dictionary.setImplementation(_fuzz_selector, address(0));
        assertEq(functions[_fuzz_selector], address(0));
        assertEq(functions[_fuzz_newSelector], _fuzz_implementation);
        /// @dev Remain length
        assertEq(functionSelectorList.length, 2);
        assertEq(functionSelectorList[0], bytes4(0));
        assertEq(functionSelectorList[1], _fuzz_newSelector);

        vm.expectEmit();
        emit ImplementationDeleted(_fuzz_newSelector);
        dictionary.setImplementation(_fuzz_newSelector, address(0));
        assertEq(functions[_fuzz_selector], address(0));
        assertEq(functions[_fuzz_newSelector], address(0));
        for (uint i; i < functionSelectorList.length; ++i) {
            assertEq(functionSelectorList[i], bytes4(0));
        }
    }

    function test_1_setImplementation_Success_EmitCorrectEvent(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        vm.expectEmit();
        emit ImplementationUpgraded(_fuzz_selector, _fuzz_implementation);
        _execute_setImplementation_WithContractAddr(_fuzz_selector, _fuzz_implementation);
    }

    //  (1) Revert
    function test_1_setImplementation_Revert_InvalidImplementation_WhenNonContract(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation.code.length == 0);
        vm.assume(_fuzz_implementation != address(0));
        vm.expectRevert(abi.encodeWithSelector(InvalidImplementation.selector, _fuzz_implementation));
        dictionary.setImplementation(_fuzz_selector, _fuzz_implementation);
    }

    function test_1_setImplementation_Revert_OwnableUnauthorizedAccount_WhenNotOwner(address _fuzz_caller) public {
        vm.assume(_fuzz_caller != address(this));
        vm.prank(_fuzz_caller);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, _fuzz_caller));
        dictionary.setImplementation(bytes4(0), address(this));
    }


    /**-----------------------
        (2) upgradeFacade
    -------------------------*/
    //  (2) Happy Path
    function test_2_upgradeFacade_Success_AssignCorrectFacade(address _fuzz_facade) public {
        vm.expectEmit();
        emit FacadeUpgraded(_fuzz_facade);
        dictionary.upgradeFacade(_fuzz_facade);
        assertEq(facade, _fuzz_facade);
    }

    //  (2) Negative
    function test_2_upgradeFacade_Revert_OwnableUnauthorizedAccount_WhenNotOwner(address _fuzz_caller) public {
        vm.assume(_fuzz_caller != address(this));
        vm.prank(_fuzz_caller);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, _fuzz_caller));
        dictionary.upgradeFacade(address(this));
    }

}
