// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";
import {IBeacon} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";

/**
    @title ERC7546: Etherscan-compatible Dictionary Proxy Contract
 */
contract DictionaryUpgradeableEtherscanProxy is ERC1967Proxy, IBeacon {
    bytes32 constant IMPLEMENTATION_FACADE_LOCATION = 0xd424c1b3bfd5781617f3695d486e7148fd014445395370f20b6d677270905d1a;

    constructor(address implementation, bytes memory _data) payable ERC1967Proxy(implementation, _data) {}

    function implementation() public view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_FACADE_LOCATION).value;
    }
}
