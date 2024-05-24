// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.23;

import {Vm} from "forge-std/Vm.sol";
import {DummyContract} from "./Dummy.sol";

Vm constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

struct UCSFunction {
    bytes4 selector;
    address implementation;
}

library Helper {
    function isReserved(address addr) internal pure returns(bool) {
        return
            // EVM Precompiles
            addr == address(0x00) ||
            addr == address(0x01) ||
            addr == address(0x02) ||
            addr == address(0x03) ||
            addr == address(0x04) ||
            addr == address(0x05) ||
            addr == address(0x06) ||
            addr == address(0x07) ||
            addr == address(0x08) ||
            addr == address(0x09) ||
            addr == address(0x0a) || // PointEvaluation
            // Foundry
            addr == 0x4e59b44847b379578588920cA78FbF26c0B4956C || // Create2Deployer
            addr == 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D || // Vm
            addr == 0x000000000000000000636F6e736F6c652e6c6f67;   // Console
    }

    function assumeNotReserved(address addr) internal pure {
        vm.assume(!isReserved(addr));
    }

    function assertContract(address addr) internal {
        assumeNotReserved(addr);
        if (addr.code.length == 0) {
            vm.etch(addr, type(DummyContract).runtimeCode);
        }
    }

    function assumeUnique(bytes4[] memory selectors) internal pure {
        bool isNotUnique;
        for (uint i; i < selectors.length; ++i) {
            for (uint j = i + 1; j < selectors.length; ++j) {
                if (selectors[i] == selectors[j]) {
                    isNotUnique = true;
                }
            }
        }
        vm.assume(!isNotUnique);
    }

    function bytes32ToAddress(bytes32 value) internal pure returns(address) {
        return address(uint160(uint256(value)));
    }

    function addressToBytes32(address value) internal pure returns(bytes32) {
        return bytes32(uint256(uint160(value)));
    }
}
