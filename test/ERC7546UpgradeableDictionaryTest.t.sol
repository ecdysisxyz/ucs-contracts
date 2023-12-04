// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2} from "forge-std/Test.sol";

import {ERC7546Behaviour} from "./suite/ERC7546Behaviour.sol";

import {Dictionary} from "../src/dictionary/Dictionary.sol";
import {IDictionary} from "../src/dictionary/IDictionary.sol";
import {ERC7546Proxy} from "../src/proxy/ERC7546Proxy.sol";
import {ERC7546Utils} from "../src/proxy/ERC7546Utils.sol";

// /// @dev A Harness Contract to retrieve the admin address declared as internal.
// contract DictionaryHarness is Dictionary {
//     constructor(address _admin) Dictionary(_admin) {}

//     function getAdmin() public view returns (address) {
//         return Dictionary.$Dictionary().admin;
//     }
// }

/**
    @title A Test Contract to verify Dictionary and Proxy compliance with specifications with forge-std/Test
 */
contract ERC7546UpgradeableDictionary is ERC7546Behaviour {
    // /// @dev Due to a bug in Solidity, we are redefining the events from the external interface file that cannot be read.
    // event ImplementationUpgraded(bytes4 indexed functionSelector, address indexed implementation);
    // event AdminChanged(address previousAdmin, address newAdmin);

    // address admin = makeAddr("ADMIN");
    // address dictionary;
    // address proxy;

    // function setUp() public virtual {
    //     dictionary = deployDictionary(admin);
    //     proxy = deployProxy(dictionary, "");
    // }

    function deployDictionary(address admin) internal override returns (address) {
        return address(new Dictionary(admin));
    }

    function deployProxy(address _dictionary, bytes memory _initData) internal override returns (address) {
        return address(new ERC7546Proxy(_dictionary, _initData));
    }

}
