// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Library version has been tested with version 5.0.0.
import {Proxy} from "openzeppelin-contracts/contracts/proxy/Proxy.sol";
import {ERC1967Utils} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";

import {ERC7546Utils} from "./ERC7546Utils.sol";
import {IDictionary} from "../dictionary/IDictionary.sol";

/**
 * @title ERC7546: Proxy Contract
 */
contract ERC7546ProxyEtherscan is Proxy {
    /**
     * @notice Specification 2.2.1
     */
    constructor(address dictionary, bytes memory _data) payable {
        ERC1967Utils.upgradeBeaconToAndCall(dictionary, _data);
    }

    /**
     * @notice Specification 2.2.2
     * @dev Return the implementation address corresponding to the function selector.
     */
    function _implementation() internal view override returns (address) {
        // return IDictionary(ERC7546Utils.getDictionary()).getImplementation(msg.sig);
        return IDictionary(ERC1967Utils.getBeacon()).getImplementation(msg.sig);
    }

    receive() external payable {}
}
