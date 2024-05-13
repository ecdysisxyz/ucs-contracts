// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Helper} from "./utils/Helper.sol";
import {Dummy} from "./utils/Dummy.sol";

import {BeaconDictionary} from "../src/dictionary/extensions/BeaconDictionary.sol";

/**
 *  @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 *
 *  Dictionary Specs
 *    (1) getImplementation(bytes4 functionSelector)
 *          MUST return Function Implementation Contract address.
 */
contract BeaconDictionaryTest is Test, BeaconDictionary {
    BeaconDictionary internal dictionary = BeaconDictionary(address(this));
    constructor() BeaconDictionary(address(new Dummy()), address(this)) {}


    /**--------------------------
        (1) getImplementation
    ----------------------------*/
    //  (1) Positive
    function test_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        vm.assume(_fuzz_implementation != address(0));
        Helper.assertContract(_fuzz_implementation);
        dictionary.upgradeTo(_fuzz_implementation);

        assertEq(dictionary.getImplementation(_fuzz_functionSelector), _fuzz_implementation);
        assertEq(dictionary.implementation(), _fuzz_implementation);
    }

}
