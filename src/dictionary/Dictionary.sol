// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {DictionaryUtils} from "./DictionaryUtils.sol";
import {DictionaryBase} from "./DictionaryBase.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
    @title ERC7546: Dictionary Contract
 */
contract Dictionary is DictionaryBase, Ownable {
    constructor(address owner) Ownable(owner) {}

    function _authorizeSetImplementation() internal override onlyOwner() {}
}
