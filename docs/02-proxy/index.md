---
title: "Proxy"
version: 0.1.0
lastUpdated: 2024-09-20
author: UCS Development Team
scope: project
type: guide
tags: [proxy, architecture, UCS, ERC-7546]
relatedDocs: ["../01-overview/index.md", "../03-dictionary/index.md"]
changeLog:
  - version: 0.1.0
    date: 2024-09-20
    description: Initial version of UCS Proxy contract documentation
---

# Proxy

The Proxy Contract is a fundamental component of the UCS (ERC-7546) architecture. It serves as the stable, unchanging address that users and other contracts interact with, while delegating calls to the appropriate Function Contracts.

## Overview

The Proxy Contract in UCS maintains the state of the contract account (nonce, balance, and storage) and delegates all calls to the appropriate Function Contracts as registered in the Dictionary Contract.

## Key Features

1. **State Management**: Maintains the contract's state.
2. **Delegation**: Delegates all calls to the appropriate Function Contracts.
3. **Upgradability**: Allows for upgrading the contract's functionality without changing its address.

## Storage

The Proxy Contract stores the Dictionary Contract address in a specific storage slot:

```solidity
bytes32 constant DICTIONARY_SLOT = 0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4;
```

This slot is calculated as `bytes32(uint256(keccak256('erc7546.proxy.dictionary')) - 1)`, following the method defined in ERC-1967.

## Events

The Proxy Contract emits an event when the Dictionary address is changed:

```solidity
event DictionaryUpgraded(address dictionary);
```

## Usage

To interact with a UCS contract, always use the Proxy Contract's address. The Proxy will handle delegating the call to the appropriate Function Contract.

```solidity
// Example usage
FunctionA(proxyAddress).functionA(arg1);
FunctionB(proxyAddress).functionB(arg1, arg2);
```

## Security Considerations

1. The Proxy Contract should not define any external functions to avoid potential collisions with function selectors registered in the Dictionary Contract.
2. Care should be taken when updating the Dictionary address, as it could potentially give control of the contract to an untrusted party.
3. The Proxy Contract is not designed to handle `DELEGATECALL`s and may behave unexpectedly if called this way.

For more detailed information on security considerations, please refer to the [Security Considerations](https://eips.ethereum.org/EIPS/eip-7546#security-considerations) document.
