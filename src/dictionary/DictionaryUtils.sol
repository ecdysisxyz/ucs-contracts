// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/**
    @title ERC7546: Dictionary Contract
 */
library DictionaryUtils {
    /// @custom:storage-location erc7201:UCS.Storage.Dictionary
    struct DictionaryStorage {
        mapping(bytes4 functionSelector => address implementation) implementations;
        address admin;
        bytes4[] functionSelectorList;
    }

    bytes32 internal constant DICTIONARY_STORAGE_LOCATION = 0xcdc329e8b4857917c1bb59ba644ac6f66cbd0414702204e909f5bbd240d25f26;

    function $Dictionary() internal pure returns (DictionaryStorage storage $) {
        assembly {
            $.slot := DICTIONARY_STORAGE_LOCATION
        }
    }

}
