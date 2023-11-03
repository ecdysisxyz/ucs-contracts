// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {console2} from "forge-std/Test.sol";

import {ERC7546Clones} from "../src/ERC7546Clones.sol";

import {ERC7546Test} from "./ERC7546Test.t.sol";
import {Dictionary} from "../src/dictionary/Dictionary.sol";
import {ERC7546Utils} from "../src/proxy/ERC7546Utils.sol";

contract ERC7546HuffProxyTest is ERC7546Test {
    // function setUp() public override {
    //     dictionary = address(new Dictionary(admin));
    //     console2.log("Dictionary Deployed");
    //     proxy = deployProxy(dictionary, bytes(""));
    // }

    function deployProxy(address _dictionary, bytes memory _initData) internal override returns (address) {
        address proxy = ERC7546Clones.clone(_dictionary, _initData);
        vm.label(proxy, "ERC7546Proxy");
        console2.log("Proxy Deployed");
        return proxy;
    }
}
