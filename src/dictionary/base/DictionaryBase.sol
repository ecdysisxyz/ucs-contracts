// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IDictionaryCore} from "../interfaces/IDictionaryCore.sol";
import {IVerifiable} from "../interfaces/IVerifiable.sol";

/**
    @title ERC7546: Dictionary Base Contract
 */
abstract contract DictionaryBase is IDictionaryCore, IVerifiable {
    mapping(bytes4 selector => address implementation) internal functions;
    bytes4[] internal functionSelectorList;
    address internal facade;

    function getImplementation(bytes4 selector) external view returns(address) {
        address _impl = functions[selector];
        if (_impl != address(0)) return _impl;
        _impl = functions[bytes4(0)];
        if (_impl != address(0)) return _impl;
        revert ImplementationNotFound(selector);
    }

    function implementation() external view returns(address) {
        return facade;
    }

    /**
     * @param interfaceId equals to the function selector
     */
    function supportsInterface(bytes4 interfaceId) external view returns(bool) {
        return functions[interfaceId] != address(0);
    }

    /**
     * @notice Specification 3.1.1.2
     */
    function supportsInterfaces() external view returns(bytes4[] memory) {
        return functionSelectorList;
    }


    //////  INTERNAL FUNCTIONS  ///////////////////////////

    function _setImplementation(bytes4 _selector, address _impl) internal virtual {
        if (_impl == address(0)) {
            __deleteImplementation(_selector);
            return;
        }

        __updateFunctionSelectorList(_selector);
        __updateImplementation(_selector, _impl);
    }

    function __deleteImplementation(bytes4 _selector) internal virtual {
        for (uint i; i < functionSelectorList.length; ++i) {
            if (functionSelectorList[i] == _selector) {
                delete functionSelectorList[i];
                break;
            }
        }
        delete functions[_selector];
        emit ImplementationDeleted(_selector);
    }

    function __updateFunctionSelectorList(bytes4 _selector) internal virtual {
        if (__existsSameSelector(_selector)) return;
        functionSelectorList.push(_selector);
        emit NewFunctionSelectorAdded(_selector);
    }

    function __existsSameSelector(bytes4 _selector) internal virtual returns(bool) {
        for (uint i; i < functionSelectorList.length; ++i) {
            if (functionSelectorList[i] == _selector) return true;
        }
        return false;
    }

    function __updateImplementation(bytes4 _selector, address _impl) internal virtual {
        if (_impl.code.length == 0) revert InvalidImplementation(_impl);
        functions[_selector] = _impl;
        emit ImplementationUpgraded(_selector, _impl);
    }

    function _upgradeFacade(address _newFacade) internal virtual {
        facade = _newFacade;
        emit FacadeUpgraded(_newFacade);
    }

}
