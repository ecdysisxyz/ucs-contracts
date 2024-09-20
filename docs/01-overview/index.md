---
title: "Overview"
version: 0.1.0
lastUpdated: 2024-09-20
author: UCS Development Team
scope: project
type: guide
tags: [overview, introduction, UCS, ERC-7546]
relatedDocs: ["../02-proxy/index.md", "../03-dictionary/index.md"]
changeLog:
  - version: 0.1.0
    date: 2024-09-20
    description: Initial version of the UCS Contracts overview
---

# Overview

Welcome to the documentation for UCS Contracts, an implementation of [ERC-7546: Upgradeable Clone for Scalable Contracts](https://eips.ethereum.org/EIPS/eip-7546). This standard introduces an innovative approach to creating modular, upgradeable, and extensible smart contracts on the Ethereum blockchain.

## Key Features

1. **Function-Level Upgradeability**: Allows for selective redirection of implementation contracts for individual function calls, providing granular control over upgrades.

2. **Factory/Clone-Friendly & Simultaneous Upgradeability**: Streamlines the process of cloning and updating Proxy contracts simultaneously, maintaining consistent functionality across different instances.

3. **Modularity**: Breaks down contract logic into separate, reusable modules, promoting code reuse and easier maintenance.

4. **Scalability**: Helps mitigate limitations posed by the contract size cap through segmentation of implementation contracts.

## Architecture

UCS Contracts consist of three main components:

1. [Proxy Contract](../02-proxy/index.md): Maintains the state and delegates calls to the appropriate Function Contracts.

2. [Dictionary Contract](../03-dictionary/index.md): Maps function selectors to their corresponding Function Contract addresses.

3. Function (Implementation) Contracts: Contain the actual logic for specific functionalities.

This architecture allows for a flexible and powerful approach to smart contract development, enabling easier management, upgrades, and extensions of contract functionality.

## Use Cases

UCS Contracts are ideal for scenarios requiring:

- Function-level upgradeability with factory/clone capabilities
- Complex systems that benefit from modular design
- Contracts that need to evolve over time without changing their address

In the following sections, we'll dive deeper into each component of the UCS Contracts system, providing detailed information on their implementation and usage.
