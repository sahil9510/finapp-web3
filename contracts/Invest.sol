// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";

interface WalletInterface{
    function completeTarget() external;
}
contract Invest is Ownable{
    
    struct Company{
        string id;
        address eoa;
        address payable assignedAddress;
        string name;
        uint target;
        uint raised;
        bool isComplete;
        address payable[] investors;
    }

    mapping(address => Company) public companyMap;
    mapping(address => mapping(address => uint)) public investedIn;
    mapping(address => Company) public counterCompanyMap;

    function createCompany(string memory _name,string memory _id,uint _target,address payable _assignedAddress) public{
        Company memory comp;
        comp.id = _id;
        comp.name = _name;
        comp.target = _target;
        comp.raised = 0;
        comp.isComplete = false;
        comp.assignedAddress = _assignedAddress;
        comp.eoa = msg.sender;
        comp.investors = new address payable[](0);

        companyMap[msg.sender] = comp;
        counterCompanyMap[_assignedAddress] = comp;
        // we return address of the new wallet generated for this company here
        // return address
    }

    function investIn(address _companyAddress) public payable returns (bool){
        require(!companyMap[_companyAddress].isComplete,"The company has finished collecting funds");
        uint amountInvested = msg.value;
        address payable assignedAddress = companyMap[_companyAddress].assignedAddress;
        (bool success,) = assignedAddress.call{value: amountInvested}("");
        require(success==true,"Fail");
        companyMap[_companyAddress].raised+=amountInvested;
        counterCompanyMap[assignedAddress].investors.push(payable(msg.sender));
        if(companyMap[_companyAddress].raised>=companyMap[_companyAddress].target){
            companyMap[_companyAddress].isComplete = true;
            counterCompanyMap[assignedAddress].isComplete=true;
            WalletInterface wallet = WalletInterface(companyMap[_companyAddress].assignedAddress);
            wallet.completeTarget();
        }
        investedIn[msg.sender][_companyAddress]=amountInvested;
        return true;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function profitGained(uint profit) external{
        Company memory comp = counterCompanyMap[msg.sender];
        require(comp.isComplete,"The company has not yet completed its target");
        uint target = comp.target;
        for(uint i=0;i<comp.investors.length;i++){
            address payable investor = comp.investors[i];
            uint amountInvested = investedIn[investor][comp.eoa];
            uint perc = amountInvested/target;
            (bool success,) = investor.call{value: perc*profit}("");
            require(success,"Failed to Send Ether");
        }        

    }
    receive() external payable {}

    fallback() external payable {}

}