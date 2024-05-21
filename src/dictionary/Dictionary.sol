// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {DictionaryBase} from "./base/DictionaryBase.sol";
import {IDictionary} from "./interfaces/IDictionary.sol";
import {Ownable} from "@oz.ucs/access/Ownable.sol";


/**
    @title ERC7546: Standard Dictionary Contract
 */
contract Dictionary is DictionaryBase, Ownable, IDictionary {
    constructor(address owner) Ownable(owner) {}

    function setImplementation(bytes4 selector, address implementation) external onlyOwner {
        _setImplementation(selector, implementation);
    }

    function upgradeFacade(address newFacade) external onlyOwner {
        _upgradeFacade(newFacade);
    }

}
