# ImmutableDictionary
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/dictionary/api-reference/ImmutableDictionary.sol)

**Inherits:**
[DictionaryBase](/dictionary/api-reference/base/DictionaryBase.sol/abstract.DictionaryBase)


## Functions
### constructor


```solidity
constructor(Function[] memory _functions, address _facade);
```

### __existsSameSelector


```solidity
function __existsSameSelector(bytes4 _selector) internal override returns (bool);
```

## Errors
### SelectorAlreadyExists

```solidity
error SelectorAlreadyExists(bytes4 selector);
```

## Structs
### Function

```solidity
struct Function {
    bytes4 selector;
    address implementation;
}
```

