// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/**
    @dev This ERC7546 helper constant & methods
 */
interface ERC7546ProxyEvents {
    /**
     * @dev Emitted when the dictionary is changed.
     */
    event DictionaryUpgraded(address indexed dictionary);

    /**
    * @dev The `dictionary` of the proxy is invalid.
     */
    // error ERC7546InvalidDictionary(address dictionary);
    error NON_CONTRACT();
}
