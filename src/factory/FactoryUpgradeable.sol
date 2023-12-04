// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.22;

// import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
// import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

// import {ERC7546Clones} from "../ERC7546Clones.sol";

// /**
//  * @title Proxy Factory Contract
//  */
// contract FactoryUpgradeable is OwnableUpgradeable, UUPSUpgradeable {
//     /// @custom:storage-location erc7201:UCS.Storage.Factory
//     struct FactoryStorage {
//         address dictionary;
//     }

//     // TODO keccak256(abi.encode(uint256(keccak256("UCS.Storage.Factory")) - 1)) & ~bytes32(uint256(0xff))
//     bytes32 private constant FACTORY_STORAGE_LOCATION = 0xa1f7aa4efc00a50b4c387d1cf192b1d1366402af5fc2208c6fc8c31291ee4456;

//     function $Factory() private pure returns (FactoryStorage storage $) {
//         assembly {
//             $.slot := FACTORY_STORAGE_LOCATION
//         }
//     }

//     function initialize(address admin, address dictionary) external initializer {
//         __Ownable_init(admin);
//         $Factory().dictionary = dictionary;
//     }

//     function clone(bytes calldata initData) returns (address) {
//         return ERC7546Clones.clone($Factory().dictionary, initData);
//     }
// }
