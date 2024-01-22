// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC1967Utils} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {StorageSlot} from "openzeppelin-contracts/contracts/utils/StorageSlot.sol";

import {ERC7546Proxy} from "./ERC7546Proxy.sol";


/**
 * @title Etherscan-compatible ERC7546Proxy Contract
 */
contract ERC7546ProxyEtherscan is ERC7546Proxy {
    constructor(address dictionary, bytes memory _data) payable ERC7546Proxy(dictionary, _data) {
        _setBeacon(dictionary);
    }

    function _setBeacon(address _newBeacon) internal {
        StorageSlot.getAddressSlot(ERC1967Utils.BEACON_SLOT).value = _newBeacon;
        emit ERC1967Utils.BeaconUpgraded(_newBeacon);
    }
}
