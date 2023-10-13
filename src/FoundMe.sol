// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FoundMe {
    AggregatorV3Interface internal dataFeed;
    uint256 minimunValueAccepted = 1; // usd
    address public immutable contractOwner;

    constructor() {
        // ETH/USD on sepolia: https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=#sepolia-testnet
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        contractOwner = msg.sender;
    }

    function foundMe() public payable returns (bool) {
        require(
            getConversionRate(msg.value) >= minimunValueAccepted,
            "not enough eth sent"
        );
        return true;
    }

    function withdraw() public OnlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "The contract has no eth innit");
        (bool sent, ) = msg.sender.call{value: contractBalance}("");
        require(sent, "Something went wrong trying to Withdraw the stored eth");
    }

    function getEthUsdPrice() public view returns (int256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = uint256(getEthUsdPrice());
        // in this case 10**dataFeed.decimals() should be 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /
            10 ** dataFeed.decimals();
        return ethAmountInUsd;
    }

    function getAggregatorVersion() public view returns (uint256) {
        return dataFeed.version();
        // or with contarct casting
        // return  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    modifier OnlyOwner() {
        require(
            msg.sender == contractOwner,
            "You are not teh owner of the contract"
        );
        _;
    }
}
