// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

import {DictionaryBase} from "./DictionaryBase.sol";
import {console2} from "forge-std/console2.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract DictionaryUpgradeable is DictionaryBase, OwnableUpgradeable, UUPSUpgradeable {
    function initialize(address owner) external initializer {
        __Ownable_init(owner);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner() {}

    function _authorizeSetImplementation() internal override onlyOwner() {
        console2.log("aaa");
    }
}
