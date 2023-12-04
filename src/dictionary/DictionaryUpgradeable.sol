// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

import {Dictionary} from "./Dictionary.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract DictionaryUpgradeable is Dictionary, OwnableUpgradeable, UUPSUpgradeable {

    constructor() Dictionary(address(0)) {}

    function _authorizeUpgrade(address newImplementation) internal override onlyAdmin {}

    function initialize(address admin) external initializer {
        _setAdmin(admin);
    }
}
