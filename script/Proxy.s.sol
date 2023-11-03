// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console2} from "forge-std/Script.sol";
// import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {ERC7546Proxy} from "../src/proxy/ERC7546Proxy.sol";
import {Dictionary} from "../src/dictionary/Dictionary.sol";

contract Proxy is Script {
    function run() public {
        // (address addr, uint256 pkey) = makeAddrAndKey("Deployer");
        // // vm.startBroadcast(pkey);
        // address dictionary = address(new Dictionary(addr));
        // address proxy = HuffDeployer
        //     .config()
        //     .with_args(bytes.concat(
        //         abi.encode(address(dictionary)),
        //         abi.encode(bytes(""))
        //     ))
        //     .set_broadcast(true)
        //     .deploy("proxy/ERC7546Proxy");
        // vm.label(proxy, "ERC7546Proxy");
        // console2.logBytes(proxy.code);
    }
}
