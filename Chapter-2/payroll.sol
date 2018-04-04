pragma solidity ^0.4.14;

contract Payroll {
    // 声明Employee结构体，包含了员工的各个属性
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    
    Employee[] employees;    // 声明Employee类型的数组，用于存储不同的员工
    address owner;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    // 主动支付给员工的应发工资
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
            employee.id.transfer(payment);
    }
    
    // 查找数组中是否有指定员工
    function _findEmployee(address employeeId) private returns (Employee, uint){
        for(uint i=0; i<employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i] ,i);
            }
        }
    }
    
    // 向数组中添加员工
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += employees[employees.length-1].salary;
    }
    
    // 在数组中删除员工
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }
    
    // 修改指定员工的工资
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[index].id = employeeId;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employee.lastPayday = employee.lastPayday + payDuration;
        employee.id.transfer(employee.salary);
    }
}
