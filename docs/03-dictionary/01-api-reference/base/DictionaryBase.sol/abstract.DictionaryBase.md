# DictionaryBase
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/dictionary/api-reference/base/DictionaryBase.sol)

**Inherits:**
[IDictionaryCore](/dictionary/api-reference/interfaces/IDictionaryCore.sol/interface.IDictionaryCore), [IVerifiable](/dictionary/api-reference/interfaces/IVerifiable.sol/interface.IVerifiable)


## State Variables
### functions

```solidity
mapping(bytes4 selector => address implementation) internal functions;
```


### functionSelectorList

```solidity
bytes4[] internal functionSelectorList;
```


### facade

```solidity
address internal facade;
```


## Functions
### getImplementation


```solidity
function getImplementation(bytes4 selector) external view returns (address);
```

### implementation


```solidity
function implementation() external view returns (address);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|equals to the function selector|


### supportsInterfaces

Specification 3.1.1.2


```solidity
function supportsInterfaces() external view returns (bytes4[] memory);
```

### _setImplementation


```solidity
function _setImplementation(bytes4 _selector, address _impl) internal virtual;
```

### __deleteImplementation


```solidity
function __deleteImplementation(bytes4 _selector) internal virtual;
```

### __updateFunctionSelectorList


```solidity
function __updateFunctionSelectorList(bytes4 _selector) internal virtual;
```

### __existsSameSelector


```solidity
function __existsSameSelector(bytes4 _selector) internal virtual returns (bool);
```

### __updateImplementation


```solidity
function __updateImplementation(bytes4 _selector, address _impl) internal virtual;
```

### _upgradeFacade


```solidity
function _upgradeFacade(address _newFacade) internal virtual;
```

