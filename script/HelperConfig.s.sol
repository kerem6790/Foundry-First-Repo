// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetworkConfig public ActiveNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            ActiveNetworkConfig = GetSepoliaEthConfig();
        } else {
            ActiveNetworkConfig = GetorCreateAnvilConfig();
        }
    }

    function GetSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory sepoliaConfig)
    {
        sepoliaConfig = NetworkConfig(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return sepoliaConfig;
    }

    function GetorCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (ActiveNetworkConfig.priceFeed != address(0)) {
            return ActiveNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig(
            address(mockpricefeed)
        );
        return anvilConfig;
    }
}
