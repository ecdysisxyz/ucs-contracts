# Upgradeable Clone Standard (UCS) Contracts Library

A library for upgradeable & cloneable smart contract development.

## Contracts
Implementations of [ERC-7546: Upgradeable Clone](https://ercs.ethereum.org/ERCS/erc-7546)
- ERC7546Proxy contract
- Dictionary contract

## Optimized proxy contract
To deploy the Huff-optimized Proxy contract from Solidity, the `ERC7546Clones.sol` library contract is utilized.

||Solidity|Huff|
|--:|--|--|
|code size|331 bytes|109 bytes|
|deployment gas without initData|90506|45276|

## Installation
To install with [Foundry](https://github.com/foundry-rs/foundry):
```bash
forge install ecdysisxyz/ucs-lib
```

***Post-Installation***: If necessary, configure remappings to ensure correct integration with your project's dependencies. Below is an example:
```remappings.txt
@ucs-lib/=lib/ucs-lib/src/
```
