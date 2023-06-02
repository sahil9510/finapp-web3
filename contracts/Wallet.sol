// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface InvestInterface {
    function profitGained(uint _profit) external;
}

contract Wallet{
    address public owner;
    InvestInterface public InvestContract;
    address payable investAddress;
    bool private hasCompletedTarget;

    constructor(address _companyAddress,address _InvestAddress){
        owner = _companyAddress;
        InvestContract = InvestInterface(_InvestAddress);
    }

    function completeTarget() external{
        hasCompletedTarget = true;
    }

    function sendMoney(address _sendTo,uint amount) public{
        require(address(this).balance>=amount,"Not enough Ether");

        (bool success,) = _sendTo.call{value: amount}("");
        require(success,"Could'nt send Ether");
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        if(hasCompletedTarget){
        uint profit = msg.value;
        (bool success,) = investAddress.call{value: profit}("");
        require(success,"Profit could'nt be sent");
        InvestContract.profitGained(profit);
        }
    }   

    // Fallback function is called when msg.data is not empty
    fallback() external payable {
        if(hasCompletedTarget){
        uint profit = msg.value;
        (bool success,) = investAddress.call{value: profit}("");
        require(success,"Profit could'nt be sent");
        InvestContract.profitGained(profit);
        }
    }
}