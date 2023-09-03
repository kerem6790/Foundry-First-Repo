// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/FundMe.sol";

import {HelperConfig} from "script/HelperConfig.s.sol";

contract Deployer is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.ActiveNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return (fundMe);
    }
}
