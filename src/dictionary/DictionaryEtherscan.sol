// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IBeacon} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";

import {DictionaryBase} from "./DictionaryBase.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract DictionaryEtherscan is IBeacon, DictionaryBase, Ownable {
    constructor(address owner) Ownable(owner) {}

    /// @dev to be verifiable on etherscan
    event FacadeUpgraded(address newFacade);
    // keccak256("erc7546.dictionary.facade") - 1
    bytes32 constant IMPLEMENTATION_FACADE_LOCATION = 0xd424c1b3bfd5781617f3695d486e7148fd014445395370f20b6d677270905d1a;
    function implementation() public view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_FACADE_LOCATION).value;
    }
    function upgradeFacade(address newFacade) external onlyOwner {
        StorageSlot.getAddressSlot(IMPLEMENTATION_FACADE_LOCATION).value = newFacade;
        emit FacadeUpgraded(newFacade);
    }

    function _authorizeSetImplementation() internal override onlyOwner() {}
}
