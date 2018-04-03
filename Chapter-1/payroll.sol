pragma solidity ^0.4.14;

contract Payroll {
    uint salaryUnit = 1 ether;
    uint salary = 1;
    address employee;    //单员工系统中，这里是frank，现在是拓展后的结果
    address owner;
    uint constant payDuration = 10 seconds;    //这里为了便于测试，将30 days修改为10 seconds
    uint lastPayday = now;
    
    //构造函数，用于初始化
    function Payroll(){
        owner = msg.sender;
    }
    
    //Update address
    function updateEmployee(address e) {
        require(msg.sender == owner);
        employee = e;
    }
    
    //Update salary
    function updateSalary(uint s){
        require(msg.sender == owner);
        salary = s * salaryUnit;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        if(msg.sender != employee){
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now){
            revert();
        }
        
        lastPayday = lastPayday + payDuration;
        employee.transfer(salary);
    }
}
