// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct Function {
    bytes4 selector;
    address implementation;
}

/**
    @title ERC7546: Dictionary Contract
 */
contract ImmutableDictionary {
    event ImplementationUpgraded(bytes4 functionSelector, address implementation);
    event FacadeUpgraded(address newFacade);

    error ImplementationNotFound(bytes4 functionSelector);
    error InvalidImplementation(address implementation);

    mapping(bytes4 functionSelector => address implementation) internal implementations;
    bytes4[] internal functionSelectorList;
    address public implementation;

    constructor(Function[] memory _funcs, address _facade) {
        for (uint i; i < _funcs.length; ++i) {
            _setImplementation(_funcs[i].selector, _funcs[i].implementation);
        }
        _upgradeFacade(_facade);
    }

    function getImplementation(bytes4 functionSelector) public view returns (address) {
        address _impl = implementations[functionSelector];
        if (_impl == address(0)) revert ImplementationNotFound(functionSelector);
        return _impl;
    }

    function _setImplementation(bytes4 _selector, address _impl) private {
        if (_impl.code.length == 0) {
            revert InvalidImplementation(_impl);
        }

        if (implementations[_selector] != address(0)) revert();
        functionSelectorList.push(_selector);

        // Add the pair of functionSelector and implementation_ address to the mapping.
        implementations[_selector] = _impl;

        // Notify the change of the mapping.
        emit ImplementationUpgraded(_selector, _impl);
    }


    /**
     * @dev The interfaceId equals to the function selector
     */
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return implementations[interfaceId] != address(0);
    }

    /**
     * @notice Specification 3.1.1.2
     */
    function supportsInterfaces() external view returns (bytes4[] memory) {
        return functionSelectorList;
    }

    // Verifiable
    function _upgradeFacade(address newFacade) private {
        implementation = newFacade;
        emit FacadeUpgraded(newFacade);
    }

}
