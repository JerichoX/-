pragma solidity ^0.4.14;

contract owned{
    address owner;

    function owned() {
        owner = msg.sender;
    }
}

contract Parent is owned {
    uint x;

    function Parent(uint _x) {
        x = _x;
    }

    function parentFunc1() internal {
        if (msg.sender == owner) selfdestruct(owner);
    }

    function parentFunc2() public {}

    function parentFunc3() external {}

    function parentFunc4() private {}
}

contract Child is Parent {
    uint y;
    function Child(uint _y) Parent (_y*_y) {
        y =  _y;
    }

    function child() {
        parentFunc2();
        this.parentFunc3();
        parentFunc1();
        //parentFunc4();    //错误！private对继承类不可见。
    }
}

contract Child2 is Parent(666) {
    uint y;
    function Child(uint _y) Parent (_y*_y) {
        y =  _y;
    }

    function child() {
        parentFunc2();
        this.parentFunc3();
        parentFunc1();
        //parentFunc4();    //错误！private对继承类不可见。
    }
}
