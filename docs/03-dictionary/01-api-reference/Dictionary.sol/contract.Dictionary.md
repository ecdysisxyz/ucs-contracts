# Dictionary
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/dictionary/api-reference/Dictionary.sol)

**Inherits:**
[DictionaryBase](/dictionary/api-reference/base/DictionaryBase.sol/abstract.DictionaryBase), Ownable, [IDictionary](/dictionary/api-reference/interfaces/IDictionary.sol/interface.IDictionary)


## Functions
### constructor


```solidity
constructor(address owner) Ownable(owner);
```

### setImplementation


```solidity
function setImplementation(bytes4 selector, address implementation) external onlyOwner;
```

### upgradeFacade


```solidity
function upgradeFacade(address newFacade) external onlyOwner;
```

