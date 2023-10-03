// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Storage} from "./Storage.sol";
import "./SharedStructs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract StorageFactory {
    using Counters for Counters.Counter;
    mapping(uint => Storage) numberToPeople;
    // reduce gas fees since that contract has alredy been deployed
    Counters.Counter private contractsNum;

    // Create a new contract at the next index, returns the index at wich was stored to the user
    function newContractAt() public returns (uint) {
        uint contractIdx = contractsNum.current();
        contractsNum.increment();
        numberToPeople[contractIdx] = new Storage();
        return contractIdx;
    }

    function newPersonAt(
        uint index,
        string calldata name,
        uint16 favNum,
        address userAdx
    ) public ValidIdx(index) {
        numberToPeople[index].setUserData(userAdx, name, favNum);
    }

    function getPersonAt(
        uint index,
        address userAdx
    ) public view ValidIdx(index) returns (SharedStructs.UserData memory) {
        Storage currContract = numberToPeople[index];
        return currContract.getUser(userAdx);
    }

    function checkContract(
        uint index
    ) public view ValidIdx(index) returns (Storage) {
        return numberToPeople[index];
    }

    modifier ValidIdx(uint index) {
        require(index >= 0, "Can't index contract at negative indexes, dummy");
        require(
            index <= contractsNum.current(),
            "There's not a contract at that index, too high"
        );
        _;
    }
}
