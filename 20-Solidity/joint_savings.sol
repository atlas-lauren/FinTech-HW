pragma solidity ^0.5.0;

// This smart contract automates the process of creating joint savings accounts.
// The contract accepts two user addresses that can control a joint savings account. 
// The contract uses ether management functions to allow users to deposit and 
// withdraw funds from the account.

contract JointSavings {
    address payable accountOne;
    address payable accountTwo;
    address public lasttoWithdraw;
    uint public lastWithdrawAmount;
    uint public contractBalance;

// The **withdraw** function allows an authorized user to withdraw funds.
// First,   it checks that the recipient of the funds is one of the two authorized users.
// Second,  it checks that the balance is sufficient to disperse the funds.
// Third,   it sets the 'lasttoWithdraw' variable as the present recipient.
//          As an efficiency measure, it first checks if the recipient of the funds in the
//          present transaction is the same as the last user to withdraw funds. If the user
//          is the same then the contract does not reset the 'lasttoWithdraw' variable to a
//          new user and keeps the value as the same user, which saves gas fees.
//          If it is a different user then the contract will update the 'lasttoWithdraw' variable.
// Fourth,  it updates the balance of the money held in the contract to the new balance.

    function withdraw(uint amount, address payable recipient) public {
        require(recipient == accountOne || recipient == accountTwo, "You do not own this account!");
        require(amount < contractBalance, "Insufficient funds!");
        recipient.transfer(amount);
        lastWithdrawAmount = amount;
        if (lasttoWithdraw != recipient) {
            lasttoWithdraw = recipient;
        }
        contractBalance = address(this).balance;
    }


// The **deposit** function allows any address to deposit funds into the account.

    function deposit() public payable {
        contractBalance = address(this).balance;
    }


// The **setAccounts** function allows the account users to input their account addresses.
// Consider for later security: we should set up a mechanism to make sure the account can
// only be set by the actual owner. Right now any user can set the account to their own 
// address and take over the funds.

    function setAccounts(address payable account1, address payable account2) public{
        accountOne = account1;
        accountTwo = account2;
    }


// Default fallback function to make sure the funds don't get stuck in the contract.
    function() external payable {
    }
}
