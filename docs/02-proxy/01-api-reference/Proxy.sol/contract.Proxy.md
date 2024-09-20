# Proxy
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/proxy/api-reference/Proxy.sol)

**Inherits:**
OZProxy

*Library version has been tested with version 5.0.0.*


## Functions
### constructor


```solidity
constructor(address dictionary, bytes memory _data) payable;
```

### _implementation

*Return the implementation address corresponding to the function selector.*


```solidity
function _implementation() internal view override returns (address);
```

