// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {console2} from "forge-std/console2.sol";
/// @dev Library version has been tested with version 5.0.0.
import {Proxy as OZProxy} from "@oz.ucs/proxy/Proxy.sol";

import {ProxyUtils} from "./ProxyUtils.sol";
import {IDictionary} from "../dictionary/IDictionary.sol";

/**
 * @title ERC7546: Proxy Contract
 */
contract Proxy is OZProxy {
    constructor(address dictionary, bytes memory _data) payable {
        console2.log(dictionary.code.length);
        ProxyUtils.upgradeDictionaryToAndCall(dictionary, _data);
        ProxyUtils.setBeacon(dictionary);
    }

    /**
     * @dev Return the implementation address corresponding to the function selector.
     */
    function _implementation() internal view override returns (address) {
        return IDictionary(ProxyUtils.getDictionary()).getImplementation(msg.sig);
    }

}
