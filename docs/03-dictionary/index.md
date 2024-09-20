---
title: "Dictionary"
version: 0.1.0
lastUpdated: 2024-09-20
author: UCS Development Team
scope: project
type: guide
tags: [dictionary, architecture, UCS, ERC-7546]
relatedDocs: ["../01-overview/index.md", "../02-proxy/index.md"]
changeLog:
  - version: 0.1.0
    date: 2024-09-20
    description: Initial version of UCS Dictionary contract documentation
---

# Dictionary

The Dictionary Contract is a crucial component of the UCS (ERC-7546) architecture. It manages the mapping of function selectors to their corresponding Function Contract addresses, acting as a dispatcher for the Proxy Contract.

## Overview

The Dictionary Contract in UCS maintains a dynamic mapping of function selectors to Function Contract addresses. This allows for function-level upgradeability and extensibility of the smart contract system.

## Key Features

1. **Function Mapping**: Manages a mapping of function selectors to Function Contract addresses.
2. **Upgradeability**: Allows for updating the implementation of existing functions.
3. **Extensibility**: Supports adding new functions to the contract post-deployment.

## Storage

The Dictionary Contract maintains a mapping of function selectors to Function Contract addresses:

```solidity
mapping(bytes4 => address) private implementations;
```

## Events

The Dictionary Contract emits an event when a function implementation is updated:

```solidity
event ImplementationUpgraded(bytes4 functionSelector, address implementation);
```

## Key Function

### getImplementation

```solidity
function getImplementation(bytes4 functionSelector) external view returns (address implementation)
```

Returns the Function Contract address for a given function selector.

## Usage

The Dictionary Contract is primarily used by the Proxy Contract to delegate calls. However, it can also be interacted with directly to manage the function mappings.

```solidity
// Example usage
dictionary.setImplementation(FunctionA.functionA.selector, newFunctionAContractAddress);
dictionary.getImplementation(FunctionA.functionA.selector); // returns newFunctionAContractAddress
```

## Security Considerations

1. Access control should be implemented to restrict who can update the function mappings.
2. Care should be taken to ensure that the Function Contract addresses being set actually implement the expected function selectors.
3. When updating function implementations, consider the potential impact on the overall system and existing state.

For more detailed information on security considerations, please refer to the [Security Considerations](https://eips.ethereum.org/EIPS/eip-7546#security-considerations) document.
