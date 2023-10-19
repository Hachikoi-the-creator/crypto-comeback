// SPDX-License-Identifier: MIT
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
pragma solidity ^0.8.18;

library UsdConverter {
    function getEthUsdPrice() internal view returns (uint256) {
        // ETH/USD on sepolia: https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=#sepolia-testnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        // prettier-ignore
        (,int answer,,,) = priceFeed.latestRoundData();
        return uint(answer * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = uint256(getEthUsdPrice());
        // in this case 10**dataFeed.decimals() should be 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /
            10 ** dataFeed.decimals();
        return ethAmountInUsd;
    }

    function getAggregatorVersion() internal view returns (uint256) {
        return dataFeed.version();
        // or with contarct casting
        // return  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
