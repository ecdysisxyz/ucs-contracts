// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {Dummy} from "test/utils/Dummy.sol";
import {Helper} from "test/utils/Helper.sol";

import {Proxy} from "src/proxy/Proxy.sol";

import {Dictionary} from "src/dictionary/Dictionary.sol";
import {ImmutableDictionary} from "src/dictionary/ImmutableDictionary.sol";
import {BeaconDictionary} from "src/dictionary/BeaconDictionary.sol";

import {SampleFunction} from "./utils/SampleFunction.sol";

/**
 *  @title UCS Contracts Integration Test
 */
contract UCSTest is Test {
    address internal dictionary;
    address internal proxy;
    address internal sampleFunction = address(new SampleFunction());

    function _assertSampleFunctionsWorkCorrectly(uint256 _number) internal {
        SampleFunction sample = SampleFunction(proxy);

        vm.assume(_number != type(uint256).max);
        sample.setNumber(_number);
        assertEq(sample.getNumber(), _number);

        sample.increment();
        assertEq(sample.getNumber(), _number + 1);
    }

    function test_withDictionary(uint256 _fuzz_number) public {
        dictionary = address(new Dictionary(address(this)));
        Dictionary(dictionary).setImplementation(SampleFunction.setNumber.selector, sampleFunction);
        Dictionary(dictionary).setImplementation(SampleFunction.increment.selector, sampleFunction);
        Dictionary(dictionary).setImplementation(SampleFunction.getNumber.selector, sampleFunction);
        proxy = address(new Proxy(dictionary, ""));
        _assertSampleFunctionsWorkCorrectly(_fuzz_number);
    }

    function test_withImmutableDictionary(uint256 _fuzz_number) public {
        ImmutableDictionary.Function[] memory functions = new ImmutableDictionary.Function[](3);
        functions[0] = ImmutableDictionary.Function(SampleFunction.setNumber.selector, sampleFunction);
        functions[1] = ImmutableDictionary.Function(SampleFunction.increment.selector, sampleFunction);
        functions[2] = ImmutableDictionary.Function(SampleFunction.getNumber.selector, sampleFunction);
        dictionary = address(new ImmutableDictionary(functions, sampleFunction));
        proxy = address(new Proxy(dictionary, ""));
        _assertSampleFunctionsWorkCorrectly(_fuzz_number);
    }

    function test_withBeaconDictionary(uint256 _fuzz_number) public {
        dictionary = address(new BeaconDictionary(sampleFunction, address(this)));
        proxy = address(new Proxy(dictionary, ""));
        _assertSampleFunctionsWorkCorrectly(_fuzz_number);
    }

}
