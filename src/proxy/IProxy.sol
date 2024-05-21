// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IProxy {
    /**
     * @dev Emitted when the dictionary is changed.
     */
    event DictionaryUpgraded(address dictionary);

    /**
    * @dev The `dictionary` of the proxy is invalid.
     */
    // error ERC7546InvalidDictionary(address dictionary);
    error NON_CONTRACT();
}
