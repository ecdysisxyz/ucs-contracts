// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {Helper} from "test/utils/Helper.sol";
import {Dummy} from "test/utils/Dummy.sol";

import {ImmutableDictionary} from "src/dictionary/ImmutableDictionary.sol";
import {IDictionaryCore} from "src/dictionary/interfaces/IDictionaryCore.sol";
import {IVerifiable} from "src/dictionary/interfaces/IVerifiable.sol";

contract ImmutableDictionaryTestHarness is Test, ImmutableDictionary {
    ImmutableDictionary internal dictionary = ImmutableDictionary(address(this));
    constructor(Function[] memory _functions, address _facade) ImmutableDictionary(_functions, _facade) {}

    function test_Success_SetCorrectParams(Function[] memory _functions, address _facade) public {
        bytes4[] memory _functionSelectorList = new bytes4[](_functions.length);
        for (uint i; i < _functions.length; ++i) {
            assertEq(functions[_functions[i].selector], _functions[i].implementation);
            _functionSelectorList[i] = _functions[i].selector;
        }
        assertEq(
            keccak256(abi.encode(_functionSelectorList)),
            keccak256(abi.encode(functionSelectorList))
        );
        assertEq(_facade, facade);
    }

    function test_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        functions[_fuzz_functionSelector] = _fuzz_implementation;

        address returnAddress = dictionary.getImplementation(_fuzz_functionSelector);

        assertEq(returnAddress, _fuzz_implementation);
    }
}

contract ImmutableDictionaryTest is Test {
    ImmutableDictionaryTestHarness internal dictionary;
    // Params
    uint constant R = 5;
    ImmutableDictionary.Function[] internal _functions;
    address internal _facade;
    bytes4[] internal _selectors;

    function _prepareCorrectParams(ImmutableDictionary.Function[R] memory _funcs, address _facade_) internal {
        for (uint i; i < _funcs.length; ++i) {
            Helper.assertContract(_funcs[i].implementation);
            _functions.push(_funcs[i]);
            _selectors.push(_funcs[i].selector);
        }
        Helper.assumeUnique(_selectors);
        _facade = _facade_;
    }


    /**-----------------
        Integration
    -------------------*/
    function test_ImmutableDictionary_Success(ImmutableDictionary.Function[R] memory _fuzz_functions, address _fuzz_facade) public {
        _prepareCorrectParams(_fuzz_functions, _fuzz_facade);
        dictionary = new ImmutableDictionaryTestHarness(_functions, _facade);

        // getImplementation()
        for (uint i; i < _fuzz_functions.length; ++i) {
            assertEq(
                dictionary.getImplementation(_fuzz_functions[i].selector),
                _fuzz_functions[i].implementation
            );
        }

        // implementation()
        assertEq(dictionary.implementation(), _fuzz_facade);

        // supportsInterface()
        for (uint i; i < _fuzz_functions.length; ++i) {
            assertTrue(dictionary.supportsInterface(_fuzz_functions[i].selector));
        }

        // supportsInterfaces()
        assertEq(
            keccak256(abi.encode(dictionary.supportsInterfaces())),
            keccak256(abi.encode(_selectors))
        );
    }


    /**--------------------------
        (1) constructor
    ----------------------------*/
    function test_constructor_Success(ImmutableDictionary.Function[R] memory _fuzz_functions, address _fuzz_facade) public {
        _prepareCorrectParams(_fuzz_functions, _fuzz_facade);
        vm.expectEmit();
        for (uint i; i < _functions.length; ++i) {
            emit IDictionaryCore.NewFunctionSelectorAdded(_functions[i].selector);
            emit IDictionaryCore.ImplementationUpgraded(_functions[i].selector, _functions[i].implementation);
        }
        emit IVerifiable.FacadeUpgraded(_facade);
        dictionary = new ImmutableDictionaryTestHarness(_functions, _facade);
        dictionary.test_Success_SetCorrectParams(_functions, _facade);
    }

    function test_constructor_Revert_IfSameSelector(ImmutableDictionary.Function[2] memory _fuzz_functions, address _fuzz_facade) public {
        vm.assume(_fuzz_functions[0].implementation != address(0));
        vm.assume(_fuzz_functions[0].selector == _fuzz_functions[1].selector);
        for (uint i; i < _fuzz_functions.length; ++i) {
            Helper.assertContract(_fuzz_functions[i].implementation);
            _functions.push(_fuzz_functions[i]);
        }
        vm.expectRevert(abi.encodeWithSelector(ImmutableDictionary.SelectorAlreadyExists.selector, _fuzz_functions[0].selector));
        new ImmutableDictionary(_functions, _fuzz_facade);
    }

}
