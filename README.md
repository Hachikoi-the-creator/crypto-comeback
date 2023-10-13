## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

# Possible vulnerabilities
# 1 wei == 1
```c#
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EtherUnits {
    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = 1 wei == 1;

    uint public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = 1 ether == 1e18;
}
```

# Delete values 
## Mappings (can be nested mappings)
```c#
    mapping(address => uint) public myMap;
    delete myMap[_addr]; // => 0x00000000000000000000000
```
## Arrays will reset to default value
```c#
    int[] myArr;
    delete myArr[0] // => 0
```

## Clever way to remove array item in the middle
jump over the item we want to remove, chaging the positon of all the items to go after it
```c#
    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }
```

**x2**
interchange the last item & the item we want to remove, then pop it out
```c#
   function remove(uint index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }
```

# Libraries
## use X as Y
```c#
// Solidity program to demonstrate 
// how to deploy a library
pragma solidity ^0.5.0;

// Defining Library
library LibExample {

    // Function to power of 
    // an unsigned integer
    function pow(
      uint a, uint b) public view returns (
      uint, address) {
        return (a ** b, address(this));
    }
}

// Defining calling contract
contract LibraryExample {
    
    // Deploying library using 
    // "for" keyword
    using LibExample for uint;
    address owner = address(this);
    
    // Calling function pow to 
    // calculate power 
    function getPow(
      uint num1, uint num2) public view returns (
      uint, address) {
        return num1.pow(num2);
    }
}
```

# Custom Errors
```c#
 // custom error
    error InsufficientBalance(uint balance, uint withdrawAmount);

    function testCustomError(uint _withdrawAmount) public view {
        uint bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
        }
    }
```

# Testing
## Zero adx
```c#
  modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }
```
## Re-entrancy attack prevention
```c#
// This modifier prevents a function from being called while
// it is still executing.
 modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }
```

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
