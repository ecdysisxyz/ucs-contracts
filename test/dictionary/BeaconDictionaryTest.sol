// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {Helper} from "test/utils/Helper.sol";
import {Dummy} from "test/utils/Dummy.sol";

import {BeaconDictionary} from "src/dictionary/BeaconDictionary.sol";

/**
 *  @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 *
 *  Dictionary Specs
 *    (1) getImplementation(bytes4 functionSelector)
 */
contract BeaconDictionaryTest is Test, BeaconDictionary {
    BeaconDictionary internal dictionary = BeaconDictionary(address(this));
    address initialImpl = Dummy.contractAddress();
    constructor() BeaconDictionary(initialImpl, address(this)) {}


    /**--------------------------
        (1) getImplementation
    ----------------------------*/
    //  (1) Positive
    function test_getImplementation_Success_ReturnCorrectAddress(bytes4 _fuzz_selector, address _fuzz_implementation) public {
        assertEq(dictionary.getImplementation(_fuzz_selector), initialImpl);

        Helper.assertContract(_fuzz_implementation);
        dictionary.upgradeTo(_fuzz_implementation);

        assertEq(_fuzz_implementation, dictionary.getImplementation(_fuzz_selector));
        assertEq(_fuzz_implementation, dictionary.implementation());
    }

}
