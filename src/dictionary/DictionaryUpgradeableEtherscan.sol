// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

import {IBeacon} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";

import {DictionaryBase} from "./DictionaryBase.sol";
// import {console2} from "forge-std/console2.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract DictionaryUpgradeableEtherscan is IBeacon, DictionaryBase, OwnableUpgradeable, UUPSUpgradeable {
    function initialize(address owner) external initializer {
        __Ownable_init(owner);
    }

    event FacadeUpgraded(address newFacade);
    // keccak256("erc7546.dictionary.facade") - 1
    bytes32 constant IMPLEMENTATION_FACADE_LOCATION = 0xd424c1b3bfd5781617f3695d486e7148fd014445395370f20b6d677270905d1a;
    function implementation() public view virtual returns (address implementation) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_FACADE_LOCATION).value;
    }
    function upgradeFacade(address newFacade) external view onlyOwner {
        StorageSlot.getAddressSlot(IMPLEMENTATION_FACADE_LOCATION).value = newFacade;
        emit FacadeUpgraded(newFacade);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner() {}

    function _authorizeSetImplementation() internal override onlyOwner() {}
}
