# ProxyUtils
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/proxy/api-reference/ProxyUtils.sol)

*Library version has been tested with version 5.0.0.*

*This ERC7546 helper constant & methods*


## State Variables
### DICTIONARY_SLOT
*The storage slot of the Dictionary contract which defines the dynamic implementations for this proxy.
This slot is the keccak-256 hash of "erc7546.proxy.dictionary" subtracted by 1.*


```solidity
bytes32 internal constant DICTIONARY_SLOT = 0x267691be3525af8a813d30db0c9e2bad08f63baecf6dceb85e2cf3676cff56f4;
```


## Functions
### getDictionary

*Returns the current dictionary address.*


```solidity
function getDictionary() internal view returns (address);
```

### upgradeDictionaryToAndCall

Change the dictionary and trigger a setup call if data is nonempty.
This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
to avoid stuck value in the contract.
Emits an [IERC7546-DictionaryUpgraded](/proxy/api-reference/IProxy.sol/interface.IProxy#dictionaryupgraded) event.


```solidity
function upgradeDictionaryToAndCall(address newDictionary, bytes memory data) internal;
```

### _setDictionary

*Stores a new dictionary in the EIP0000 dictionary slot.*


```solidity
function _setDictionary(address newDictionary) private;
```

### _checkNonPayable


```solidity
function _checkNonPayable() private;
```

### setBeacon


```solidity
function setBeacon(address newBeacon) internal;
```

