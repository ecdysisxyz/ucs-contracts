// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {DictionaryBase} from "./base/DictionaryBase.sol";
import {console2} from "forge-std/console2.sol";

/**
    @title ERC7546: Immutable Dictionary Contract
 */
contract ImmutableDictionary is DictionaryBase {
    struct Function {
        bytes4 selector;
        address implementation;
    }

    error SelectorAlreadyExists(bytes4 selector);

    constructor(Function[] memory _functions, address _facade) {
        for (uint i; i < _functions.length; ++i) {
            _setImplementation(_functions[i].selector, _functions[i].implementation);
        }
        _upgradeFacade(_facade);
    }

    function __existsSameSelector(bytes4 _selector) internal override returns(bool) {
        for (uint i; i < functionSelectorList.length; ++i) {
            if (functionSelectorList[i] == _selector) revert SelectorAlreadyExists(_selector);
        }
        return false;
    }

}
