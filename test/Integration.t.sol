// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {Deployer} from "../script/Deployer.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {FundFundMe, WithdrawFundMe} from "script/Interactions.s.sol";

contract Integration is Test {
    FundMe fundMe;
    uint256 constant START_VALUE = 2 ether;

    address USER = makeAddr("user");

    function setUp() external {
        Deployer deployer = new Deployer();
        fundMe = deployer.run();
        vm.deal(USER, START_VALUE);
    }

    function testFundMeScript() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}
