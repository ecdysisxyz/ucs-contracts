// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IBeacon} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";

/**
    @title ERC7546: Etherscan-compatible Dictionary Proxy Contract
 */
contract DictionaryUpgradeableEtherscanProxy is ERC1967Proxy, IBeacon {
    constructor(address implementation, bytes memory _data) payable ERC1967Proxy(implementation, _data) {}
    function implementation() external view returns (address) {}
}
