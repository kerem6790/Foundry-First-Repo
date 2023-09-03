// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {Deployer} from "../script/Deployer.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant START_VALUE = 1 ether;

    address USER = makeAddr("user");

    function setUp() external {
        Deployer deployer = new Deployer();
        fundMe = deployer.run();
        vm.deal(USER, START_VALUE);
    }

    function testMinimumUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5");
    }

    function testVersion() public {
        assertEq(fundMe.getVersion(), 4, "Version should be 4 ");
    }

    function testIfETHMinAmountIsAccurate() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testIfListIsUpdated() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address expected = fundMe.getFunder(0);
        assertEq(expected, address(USER), "Funder should be this address");
    }

    function testIfCheckValue() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 expected = fundMe.getAddressToAmountFunded(USER);
        assertEq(expected, SEND_VALUE, "Value should be 0.1");
    }

    modifier Funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testIfOwner() public Funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdraw() public Funded {
        uint256 startingFundmeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingFundmeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(
            endingFundmeBalance,
            0,
            "Fundme balance should be 0 after withdraw"
        );

        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundmeBalance,
            "Owner balance should be 0.1 after withdraw"
        );
    }
}
