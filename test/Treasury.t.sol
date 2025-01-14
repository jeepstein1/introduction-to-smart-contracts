// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "contracts/Treasury.sol";


contract TreasuryTest is Test {
    Treasury private treasury;
    address public owner;
    address public contractAddress;


    function setUp() public {
        owner = address(7);
        vm.startPrank(owner);


        treasury = new Treasury();
        contractAddress = address(treasury);


        vm.stopPrank();
    }


    function testInitializeOwner() public {
        assertEq(treasury.owner(), owner);
    }


    function testOwnerTransferOwnership() public {
        vm.prank(owner);
        treasury.transferOwnership(address(1));
        assertEq(address(1), treasury.owner());
    }


    function testNotOwnerTransferOwnership() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.transferOwnership(address(1));
        assertEq(owner, treasury.owner());
    }


    function testSuccessfulDeposit() public {
        vm.deal(address(1), 0.5 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.2 ether}();
        assertEq(contractAddress.balance, 0.2 ether);
        assertEq(address(1).balance, 0.3 ether);
    }


    function testInvalidDepositAmount() public {
        vm.deal(address(1), 0.5 ether);
        vm.prank(address(1));
        vm.expectRevert("Treasury: Deposit amount should be greater than zero");
        treasury.deposit{value: 0 ether}();
    }


    function testSuccessfulWithdraw() public {
        // supply contract with ether
        vm.deal(address(1), 0.5 ether);
               vm.prank(address(1));
        treasury.deposit{value: 0.5 ether}();


        vm.prank(owner);
        treasury.withdraw(0.4 ether, address(2));
        assertEq(contractAddress.balance, 0.1 ether);
        assertEq(address(2).balance, 0.4 ether);
    }


    function testNotOwnerWithdraw() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.withdraw(0.5 ether, address(2));
    }


    function testWithdrawReceiverZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: receiver is zero address");
        treasury.withdraw(0.5 ether, address(0));
    }


    function testWithdrawInvalidAmount() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: Not enough balance to withdraw");
        treasury.withdraw(0.15 ether, address(1));
    }


    function testSuccessfulWithdrawAll() public {
        // supply contract with ether
        vm.deal(address(1), 0.8 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.8 ether}();
        assertEq(contractAddress.balance, 0.8 ether);


        vm.prank(owner);
        treasury.withdrawAll();
        assertEq(contractAddress.balance, 0 ether);
        assertEq(owner.balance, 0.8 ether);
    }

   function testNotOwnerWithdrawAll() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.withdrawAll();
    }


    function testWithdrawAllNoBalance() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: No balance to withdraw");
        treasury.withdrawAll();
    }


    function testGetBalance() public {
        // supply contract with ether
        vm.deal(address(1), 0.8 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.8 ether}();


        assertEq(treasury.getBalance(), 0.8 ether);
    }

    //test function for setDepositVal and getDepositVal - Jenny
    function setWithdrawalVal() public {
        //set withdrawal value to 100, used for later retrieval
        treasury.setWithdrawalVal(100);
        //test equality of prespecified deposit of 100
        assertEq(treasury.getWithdrawalVal(), 100);
    }

    //test function for setDepositVal and getDepositVal - Jenny
    function testSetDepositVal() public {
        //set deposit value to 100, used for later retrieval
        treasury.setDepositVal(100);
        //test equality of prespecified deposit of 100
        assertEq(treasury.getDepositVal(), 100);
    }

    //test function for setProjectedBal and getProjectedBal - Jenny
    function testSetProjectedBal() public {
        //set deposit value to 100, used for later retrieval
        treasury.setProjectedBal(100);
        //test equality of prespecified deposit of 100
        assertEq(treasury.getProjectedBal(), 100);
    }


    //test function for setTransactionStatus and getTransactionStatus - Ian
    function testSetTransactionStatus() public {
        //test with setting it True since it defaults to false
        treasury.setTransactionStatus(true);
        //check that the getter function works and the setter function set it to true
        assertEq(treasury.getTransactionStatus(), true);
    }

    //test function for setTransactionType and getTransactionType - Ian
    function testSetTransactionType() public {
        //test with setting it True since it defaults to false
        treasury.setTransactionType(true);
        //check that the getter function works and the setter function set it to true
        assertEq(treasury.getTransactionType(), true);
    }

    //test function for setTransactionAmount and getTransactionAmount - Ian
    function testSetTransactionAmount() public {
        //test with setting amount to 100
        treasury.setTransactionAmount(100);
        //check to ensure getter function works and the setter function set it successfully to 100
        assertEq(treasury.getTransactionAmount(), 100);
    }


    //test function for isBalanceLow - Rodrigo
    function testIsBalanceLow() public {
        //test if balance is low after withdrawing 1 from the account
        // treasury.withdraw(0.4 ether,address(0));
        //make sure that it is still false, 1 shouldn't bring the
        // account balance to <10 unless it was 11 before
        uint256 balance = treasury.getBalance();
        if (balance < 10){
            assertEq(treasury.isBalanceLow(), true); 
        }
        else {
            assertEq(treasury.isBalanceLow(), false); 
        }
    }
}
