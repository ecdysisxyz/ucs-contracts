// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";
// import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {Proxy} from "../src/proxy/Proxy.sol";
import {Dictionary} from "../src/dictionary/Dictionary.sol";

contract DeployProxy is Script {
    address admin = makeAddr("ADMIN");
    address dictionary;
    address proxy;

    function run() public {
        dictionary = address(new Dictionary(admin));
        proxy = deployProxy(dictionary, "");
    }

    function deployProxy(address _dictionary, bytes memory _initData) internal virtual returns (address) {
        return address(new Proxy(_dictionary, _initData));
    }
}
