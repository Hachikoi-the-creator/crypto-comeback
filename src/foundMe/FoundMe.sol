// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {UsdConverter} from "./UsdCoverter.sol";

contract FoundMe {
    using UsdConverter for uint256;
    address public immutable contractOwner;

    address[] public donorsArray;
    mapping(address => uint) addressToAmountDonated;
    uint256 minimunValueAccepted = 1; // usd

    constructor() {
        contractOwner = msg.sender;
    }

    function foundMe() public payable returns (bool) {
        require(
            msg.value.getConversionRate() >= minimunValueAccepted,
            "not enough eth sent"
        );
        addressToAmountDonated[msg.sender] += msg.value;
        return true;
    }

    function withdraw() public OnlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "The contract has no eth innit");
        (bool sent, ) = msg.sender.call{value: contractBalance}("");
        require(sent, "Something went wrong trying to Withdraw the stored eth");

        // reset founders listings
        uint donosAmount = donorsArray.length;
        for (uint i = 0; i < donosAmount; i++) {
            addressToAmountDonated[donorsArray[i]] = 0;
            donorsArray.pop();
        }
    }

    modifier OnlyOwner() {
        require(
            msg.sender == contractOwner,
            "You are not teh owner of the contract"
        );
        _;
    }
}
