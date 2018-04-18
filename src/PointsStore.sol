pragma solidity ^0.4.0;

contract Test {
    uint points = 0;

     function addPoints(uint _points) public {
        points += _points;
    }

    function getPoints() public constant returns(uint){
        return points;
    }
}
