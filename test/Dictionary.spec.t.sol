// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2} from "forge-std/Test.sol";

import {Dictionary} from "../src/Dictionary.sol";
import {Proxy} from "../src/Proxy.sol";
import {Helper} from "./utils/Helper.sol";

// /// @dev A Harness Contract to retrieve the owner address declared as internal.
// contract DictionaryHarness is Dictionary {
//     constructor(address _owner) Dictionary(_owner) {}

//     function getAdmin() public view returns (address) {
//         return DictionaryUtils.$Dictionary().owner;
//     }
// }

/**
    @title A test to verify that the Dictionary Contract meets the specifications of the ERC-7546 standard.
 */
contract DictionarySpecTest is Test {
    Dictionary internal dictionary;

    function setUp() public virtual {
        dictionary = new Dictionary(address(this));
    }

    /**
     *  Dictionary
     *    (1) MUST implement `getImplementation(bytes4 functionSelector)`
     *          to return Function Implementation Contract address.
     *    (2) SHOULD implement `setImplementation(bytes4 functionSelector, address implementation)`
     *      (2.1) to update or add new function selectors and their corresponding Function Implementation Contract addresses to the mapping.
     *      (2.2) and SHOULD be communicated through an event (or log).
     *    (3) is RECOMMENDED to implement
     *      (3.1) `supportsInterface(bytes4 interfaceID)` defined in ERC-165
     *              to indicate which interfaces are supported by the contracts referenced in the mapping.
     *      (3.2) `supportsInterfaces()`
     *              to return a list of registered interfaceIDs
     */

    /**
        @notice Verify (1), (2)
     */
    function test_Success_setImplementation_getImplementation(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        Helper.assertContract(_fuzz_implementation);

        vm.expectEmit();
        emit Dictionary.ImplementationUpgraded(_fuzz_functionSelector, _fuzz_implementation);
        dictionary.setImplementation(_fuzz_functionSelector, _fuzz_implementation);

        assertEq(dictionary.getImplementation(_fuzz_functionSelector), _fuzz_implementation);
    }

    /**
        @notice Verify (3-1)
     */
    function test_Success_supportsInterface(bytes4 _fuzz_functionSelector, address _fuzz_implementation) public {
        test_Success_setImplementation_getImplementation(_fuzz_functionSelector, _fuzz_implementation);
        assertTrue(dictionary.supportsInterface(_fuzz_functionSelector));
    }

    /**
        @notice Verify (3-2)
     */
    function test_Success_supportsInterfaces(bytes4[100] calldata _fuzz_functionSelector, address[100] calldata _fuzz_implementation) public {
        for (uint i; i < _fuzz_functionSelector.length;) {
            test_Success_setImplementation_getImplementation(_fuzz_functionSelector[i], _fuzz_implementation[i]);
            unchecked {
                ++i;
            }
        }

        bytes4[] memory interfaces = Dictionary(dictionary).supportsInterfaces();
        if (interfaces.length == _fuzz_functionSelector.length) {
            for (uint i; i < _fuzz_functionSelector.length;) {
                assertEq(interfaces[i], _fuzz_functionSelector[i]);
                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint i; i < interfaces.length;) {
                bool isMatch;
                for (uint j; j < _fuzz_functionSelector.length;) {
                    if (interfaces[i] == _fuzz_functionSelector[j]) {
                        isMatch = true;
                        break;
                    }
                    unchecked {
                        ++j;
                    }
                }
                assertTrue(isMatch);
                unchecked {
                    ++i;
                }
            }
        }
    }
}
