# Upgradeable Clone Standard (UCS) Contracts Library

A library for upgradeable & cloneable smart contract development.

## Contracts
Implementations of [ERC-7546: Upgradeable Clone](https://ercs.ethereum.org/ERCS/erc-7546)
- ERC7546Proxy contract
- Dictionary contract

### Optimized proxy contract
To deploy the Huff-optimized Proxy contract from Solidity, the `ERC7546Clones.sol` library contract is utilized.

||Solidity|Huff|
|--:|--|--|
|code size|338 bytes|119 bytes|
|deployment gas without initData|91,906 gas|47,276 gas|

## Installation
To install with [Foundry](https://github.com/foundry-rs/foundry):
```bash
forge install ecdysisxyz/ucs-contracts
```

***Post-Installation***: If necessary, configure remappings to ensure correct integration with your project's dependencies. Below is an example:
```remappings.txt
@ucs/=lib/ucs-contracts/src/
```
