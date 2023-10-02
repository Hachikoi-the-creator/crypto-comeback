// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Storage} from "./Storage.sol";
import "./SharedStructs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract StorageFactory {
    mapping(uint => Storage) numberToPeople;
    // reduce gas fees since that contract has alredy been deployed
    using Counters for Counters.Counter;

    function newContractAt(uint index) public {
        numberToPeople[index] = new Storage();
    }

    function newPersonAt(
        uint index,
        string calldata name,
        uint16 favNum
    ) public {
        //require(numberToPeople[index], "u suck");// dunno how to check if the contarct exist, sadge
        numberToPeople[index].setUserData(name, favNum);
    }

    // USER ADX WILL ALWAYS BE THIS CONTRACT ADX ! as long as the other conract get's it automatically with msg.sender
    function getPersonAt(
        uint index,
        address userAdx
    ) public view returns (SharedStructs.UserData memory) {
        Storage currContract = numberToPeople[index];
        return currContract.getUser(userAdx);
    }

    function checkContract(uint index) public view returns (Storage) {
        return numberToPeople[index];
    }
}
