// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.22;

// import {Test, console2} from "forge-std/Test.sol";

// import {Dictionary} from "../src/Dictionary.sol";
// import {Proxy} from "../src/Proxy.sol";
// import {Helper} from "./utils/Helper.sol";

// // /// @dev A Harness Contract to retrieve the owner address declared as internal.
// // contract DictionaryHarness is Dictionary {
// //     constructor(address _owner) Dictionary(_owner) {}

// //     function getAdmin() public view returns (address) {
// //         return DictionaryUtils.$Dictionary().owner;
// //     }
// // }

// /**
//     @title A test to verify that the Proxy Contract meets the specifications of the ERC-7546 standard.
//  */
// contract ProxySpecTest is Test {
//     /// @dev Due to a bug in Solidity, we are redefining the events from the external interface file that cannot be read.
//     event ImplementationUpgraded(bytes4 indexed functionSelector, address indexed implementation);
//     event AdminChanged(address previousAdmin, address newAdmin);

//     address owner = makeAddr("OWNER");
//     address dictionary;
//     address proxy;

//     function setUp() public virtual {
//         dictionary = address(new Dictionary(owner));
//         proxy = address(new Proxy(dictionary, ""));
//     }

//     /**
//      *  Proxy
//      *    (1) SHOULD store the Dictionary Contract address
//      *      (1.1) in the storage slot `0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4`, obtained as `bytes32(uint256(keccak256('erc7546.proxy.dictionary')) - 1)`
//      *      (1.2) and SHOULD emit events `event DictionaryUpgraded(address dictionary)` when the dictionary address changed
//      *    (2) MUST perform a delegatecall to the corresponding Function Contract address retrieved from the Dictionary Contract using the `getImplementation(bytes4 functionSelector)`
//      *         for every invocation made via
//      *          (2.1) `CALL`
//      *          (2.2) `STATICCALL`
//      */

//     /**
//         @notice Verify (1)
//      */
//     function test_Success_constructor_setDictionary(address _fuzz_dictionary) public {
//         Helper.assumeNotReserved(_fuzz_dictionary);
//         vm.assume(
//             _fuzz_dictionary != address(proxy) &&
//             _fuzz_dictionary != address(this)
//         );

//         if (_fuzz_dictionary.code.length == 0
//             && _isNotTestContracts(_fuzz_dictionary)
//             && _fuzz_dictionary != address(dictionary)
//         ) {
//             deployCodeTo("Dummy.sol", _fuzz_dictionary);
//         }

//         vm.expectEmit();
//         emit ERC7546ProxyEvents.DictionaryUpgraded(_fuzz_dictionary);
//         // address _proxy = address(new ERC7546Proxy(_fuzz_dictionary, bytes("")));
//         address _proxy = _deployProxy(_fuzz_dictionary, "");
//         assertEq(
//             address(uint160(uint256(vm.load(_proxy, ERC7546Utils.DICTIONARY_SLOT)))),
//             _fuzz_dictionary
//         );
//         console2.logBytes(_proxy.code);
//     }
//     function test_Revert_constructor_setDictionary_withEmptyDictionary(address _fuzz_dictionary) public {
//         vm.assume(
//             _isNotTestContracts(_fuzz_dictionary) &&
//             _fuzz_dictionary != address(dictionary) &&
//             _fuzz_dictionary != address(proxy)
//         );
//         // vm.expectRevert(abi.encodeWithSelector(ERC7546Utils.ERC7546InvalidDictionary.selector, _fuzz_dictionary));
//         vm.expectRevert("NON_CONTRACT");
//         _deployProxy(_fuzz_dictionary, "");
//     }

//     /**
//         @notice Verify (2)
//      */
//     function test_Success_delegatecall_AllCallsAreForwardedToDictionary(bytes calldata _fuzz_data, address _fuzz_implementation) public {
//         vm.assume(_fuzz_data.length >= 4 && bytes4(_fuzz_data) != bytes4(""));
//         vm.assume(_fuzz_implementation != address(vm));
//         test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_data), _fuzz_implementation);

//         vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_data)));
//         vm.expectCall(_fuzz_implementation, _fuzz_data);
//         proxy.call(_fuzz_data);
//     }
//     function test_Success_delegatecall_AllStaticCallsAreForwardedToDictionary(bytes calldata _fuzz_data, address _fuzz_implementation) public {
//         vm.assume(_fuzz_data.length >= 4 && bytes4(_fuzz_data) != bytes4(""));
//         vm.assume(_fuzz_implementation != address(vm));
//         test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_data), _fuzz_implementation);

//         vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_data)));
//         vm.expectCall(_fuzz_implementation, _fuzz_data);
//         proxy.staticcall(_fuzz_data);
//     }
//     function test_Revert_delegatecall_UnregisteredImplementation(bytes4 _fuzz_functionSelector, address _fuzz_implementation, bytes calldata _fuzz_calldata) public {
//         test_Dictionary_Success_setImplementation_getImplementation(bytes4(_fuzz_functionSelector), _fuzz_implementation);

//         vm.assume(_fuzz_functionSelector != bytes4(_fuzz_calldata));

//         /// @dev when the calldata is empty, receive()
//         vm.assume(_fuzz_calldata.length != 0);

//         vm.expectCall(dictionary, abi.encodeWithSelector(Dictionary.getImplementation.selector, bytes4(_fuzz_calldata)));
//         vm.expectRevert(abi.encodeWithSelector(Dictionary.ImplementationNotFound.selector, bytes4(_fuzz_calldata)));
//         proxy.call(_fuzz_calldata);
//     }

//     function _isNotTestContracts(address addr) internal view returns (bool) {
//         return (
//             addr != address(console2)
//             && addr != address(vm)
//             && addr != address(this)
//             && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C // Create2Deployer
//         );
//     }

//     function test_Success_SimpleReceiveETH(uint256 _fuzz_amount) external {
//         vm.assume(address(this).balance >= _fuzz_amount);
//         uint256 _proxyBalanceBeforeReceive = proxy.balance;
//         payable(proxy).call{value: _fuzz_amount}("");
//         uint256 _proxyBalanceAfterReceive = proxy.balance;

//         assertLe(_proxyBalanceBeforeReceive, _proxyBalanceAfterReceive);
//     }
// }
