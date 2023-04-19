// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/access/Ownable.sol";


/*
  By default, the owner of an Ownable contract is the account that deployed it.
*/
contract Treasury is Ownable {

    //initialize deposit variable - setDepositVal function
    uint256 public amountDeposited = 0;
    //initialize withdrawal variable - setWithdrawalVal function
    uint256 public amountWithdrawn = 0;
    //initialize balance value to track deposits and withdrawals
    uint256 public currentBalance = 0;
    //initialize projectedBal
    uint256 public projectedBal = 0;
    bool public isTransactionPublic = false; 

    // Function to deposit Ether into the contract
    function deposit() external payable {
        require(
            msg.value > 0,
            "Treasury: Deposit amount should be greater than zero"
        );


        // The balance of the contract is automatically updated
    }

    // Function to withdraw Ether from the contract to specified address
    function withdraw(uint256 amount, address receiver) external onlyOwner {
        require(
            address(receiver) != address(0),
            "Treasury: receiver is zero address"
        );
        require(
            address(this).balance >= amount,
            "Treasury: Not enough balance to withdraw"
        );


        (bool send, ) = receiver.call{value: amount}("");
        require(send, "To receiver: Failed to send Ether");
    }

    // Function to allow the owner to withdraw the entire balance
    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Treasury: No balance to withdraw");


        (bool send, ) = msg.sender.call{value: balance}("");
        require(send, "To owner: Failed to send Ether");
    }


    // Function to get the contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    //function to set the value of a deposit made- Jenny
    function setDepositVal (uint depositVal) public{
        amountDeposited =  depositVal;
        currentBalance += amountDeposited;
    }
    //function to retrieve the deposit value set above - Jenny
    function getDepositVal() external view returns (uint256){
        return amountDeposited;
    }

    //function to set the value of a withdrawal made- Jenny
    function setWithdrawalVal (uint withdrawalVal) public{
        amountWithdrawn =  withdrawalVal;
        currentBalance -= amountWithdrawn;
    }
    //function to retrieve the withdrawal value set above - Jenny
    function getWithdrawalVal() external view returns (uint256){
        return amountWithdrawn;
    }
    // function to take in a depositValue and add it to the current balance to generate a projected balance - Jenny
    function setProjectedBal(uint depositVal) public{
        projectedBal = currentBalance +  depositVal;
    }

    //function to retrieve the projected balance value set above - Jenny
    function getProjectedBal() external view returns (uint256){
        return projectedBal;
    }

    //function to set whether transaction is publicly viewable - Ian
    function setTransactionStatus (bool isPublic) public{
        isTransactionPublic = isPublic;
    }
    function getTransactionStatus() external view returns (bool){
        return isTransactionPublic;
    }

    //function that notifies user if the account balancein below 10 - Rodrigo
     function isBalanceLow() external view returns (bool){
        return address(this).balance < 10;
    }
}
