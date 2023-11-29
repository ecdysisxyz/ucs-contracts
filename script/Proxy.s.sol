// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console2} from "forge-std/Script.sol";
// import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {ERC7546Proxy} from "../src/proxy/ERC7546Proxy.sol";
import {Dictionary} from "../src/dictionary/Dictionary.sol";

contract Proxy is Script {
    address admin = makeAddr("ADMIN");
    address dictionary;
    address proxy;

    function run() public {
        dictionary = address(new Dictionary(admin));
        proxy = deployProxy(dictionary, "");
    }

    function deployProxy(address _dictionary, bytes memory _initData) internal virtual returns (address) {
        return address(new ERC7546Proxy(_dictionary, _initData));
    }
}
