# BeaconDictionary
[Git Source](https://github.com/ecdysisxyz/ucs-contracts/blob/34536bdf106911e4f7742714a91893bacfe09985/dictionary/api-reference/BeaconDictionary.sol)

**Inherits:**
UpgradeableBeacon


## Functions
### constructor


```solidity
constructor(address implementation_, address initialOwner) UpgradeableBeacon(implementation_, initialOwner);
```

### getImplementation


```solidity
function getImplementation(bytes4 selector) external view returns (address);
```

