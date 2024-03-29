// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import {Helper} from "./utils/Helper.sol";

import {Proxy} from "../src/Proxy.sol";

/**
 *  @title A test to verify that the Proxy Contract meets the specifications of the ERC-7546 standard.
 *
 *  Proxy Specs
 *    (1) Dictionary Contract address
 *      (1.1) SHOULD be stored in the storage slot `0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4`,
 *        (1.1.1) obtained as `bytes32(uint256(keccak256('erc7546.proxy.dictionary')) - 1)`
 *      (1.2) SHOULD emit events `event DictionaryUpgraded(address dictionary)`
 *            when the dictionary address changed
 *    (2) MUST perform a delegatecall to the corresponding Function Contract address retrieved from the Dictionary Contract using the `getImplementation(bytes4 functionSelector)`
 *         for every invocation made via
 *          (2.1) `CALL`
 *          (2.2) `STATICCALL`
 */
contract ProxySpecTest is Test, Proxy {
    Proxy internal proxy;
    constructor() Proxy(address(this), "") {}


    /**------------------------------------
        (1) Dictionary Contract address
    --------------------------------------*/
    //  (1.1) Positive
    function test_storeDictionaryAddr_Success_StoreInCorrectSlot() public {
        address dictionaryAddr = Helper.bytes32ToAddress(vm.load(address(this), Proxy.DICTIONARY_SLOT));
        assertEq(dictionaryAddr, address(this));
    }

    //  (1.1.1) Positive
    function test_SlotIsObtainedAsERC1967Style() public {
        bytes32 slot = Proxy.DICTIONARY_SLOT;
        assertEq(slot, 0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4);
        assertEq(slot, bytes32(uint256(keccak256('erc7546.proxy.dictionary')) - 1));
    }

    //  (1.2) Positive
    /// @dev The function _upgradeDictionaryToAndCall is solely responsible for changing the dictionary address.
    function test_upgradeDictionaryAndCall_Success_EmitCorrectEvent(address _fuzz_dictionary) public {
        vm.expectEmit();
        emit DictionaryUpgraded(_fuzz_dictionary);
        _upgradeDictionaryToAndCall(_fuzz_dictionary, "");
    }

    // /**
    //     @notice Verify (2)
    //  */
    // function test_Success_delegatecall_AllCallsAreForwardedToDictionary(bytes calldata _fuzz_data, address _fuzz_implementation) public {
    //     vm.assume(_fuzz_data.length >= 4 && bytes4(_fuzz_data) != bytes4(""));
    //     vm.assume(_fuzz_implementation != address(vm));
    //     test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_data), _fuzz_implementation);

    //     vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_data)));
    //     vm.expectCall(_fuzz_implementation, _fuzz_data);
    //     proxy.call(_fuzz_data);
    // }
    // function test_Success_delegatecall_AllStaticCallsAreForwardedToDictionary(bytes calldata _fuzz_data, address _fuzz_implementation) public {
    //     vm.assume(_fuzz_data.length >= 4 && bytes4(_fuzz_data) != bytes4(""));
    //     vm.assume(_fuzz_implementation != address(vm));
    //     test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_data), _fuzz_implementation);

    //     vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_data)));
    //     vm.expectCall(_fuzz_implementation, _fuzz_data);
    //     proxy.staticcall(_fuzz_data);
    // }
    // function test_Revert_delegatecall_UnregisteredImplementation(bytes4 _fuzz_functionSelector, address _fuzz_implementation, bytes calldata _fuzz_calldata) public {
    //     test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_functionSelector), _fuzz_implementation);

    //     vm.assume(_fuzz_functionSelector != bytes4(_fuzz_calldata));

    //     /// @dev when the calldata is empty, receive()
    //     vm.assume(_fuzz_calldata.length != 0);

    //     vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_calldata)));
    //     vm.expectRevert(abi.encodeWithSelector(Dictionary.ImplementationNotFound.selector, bytes4(_fuzz_calldata)));
    //     proxy.call(_fuzz_calldata);
    // }

    // function _isNotTestContracts(address addr) internal view returns (bool) {
    //     return (
    //         addr != address(console2)
    //         && addr != address(vm)
    //         && addr != address(this)
    //         && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C // Create2Deployer
    //     );
    // }

    // function test_Success_SimpleReceiveETH(uint256 _fuzz_amount) external {
    //     vm.assume(address(this).balance >= _fuzz_amount);
    //     uint256 _proxyBalanceBeforeReceive = proxy.balance;
    //     payable(proxy).call{value: _fuzz_amount}("");
    //     uint256 _proxyBalanceAfterReceive = proxy.balance;

    //     assertLe(_proxyBalanceBeforeReceive, _proxyBalanceAfterReceive);
    // }
}
