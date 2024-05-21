// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @dev Library version has been tested with version 5.0.0.
import {Address} from "@oz.ucs/utils/Address.sol";
import {StorageSlot} from "@oz.ucs/utils/StorageSlot.sol";
import {ERC1967Utils} from "@oz.ucs/proxy/ERC1967/ERC1967Utils.sol";
import {IBeacon} from "@oz.ucs/proxy/beacon/IBeacon.sol";

import {IProxy} from "./IProxy.sol";
import {IDictionary} from "../dictionary/interfaces/IDictionary.sol";

/**
    @dev This ERC7546 helper constant & methods
 */
library ProxyUtils {
    /**
     * @dev The storage slot of the Dictionary contract which defines the dynamic implementations for this proxy.
     * This slot is the keccak-256 hash of "erc7546.proxy.dictionary" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant DICTIONARY_SLOT = 0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4;

    /**
     * @dev Returns the current dictionary address.
     */
    function getDictionary() internal view returns (address) {
        return StorageSlot.getAddressSlot(DICTIONARY_SLOT).value;
    }

    /**
     * Change the dictionary and trigger a setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     *
     * Emits an {IERC7546-DictionaryUpgraded} event.
     */
    function upgradeDictionaryToAndCall(address newDictionary, bytes memory data) internal {
        _setDictionary(newDictionary);
        emit IProxy.DictionaryUpgraded(newDictionary);

        if (data.length > 0) {
            Address.functionDelegateCall(IDictionary(newDictionary).getImplementation(bytes4(data)), data);
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Stores a new dictionary in the EIP0000 dictionary slot.
     */
    function _setDictionary(address newDictionary) private {
        if (newDictionary.code.length == 0) {
            // revert ERC7546InvalidDictionary(newDictionary);
            revert("NON_CONTRACT");
        }
        StorageSlot.getAddressSlot(DICTIONARY_SLOT).value = newDictionary;
    }

    function _checkNonPayable() private {
        if (msg.value > 0) {
            revert ERC1967Utils.ERC1967NonPayable();
        }
    }

    function setBeacon(address newBeacon) internal {
        StorageSlot.getAddressSlot(ERC1967Utils.BEACON_SLOT).value = newBeacon;
    }

}
