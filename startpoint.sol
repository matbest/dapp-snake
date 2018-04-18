pragma solidity ^0.4.21;

import "./Ownable.sol";


contract StartPoint is Ownable
{
    string public myIpfsString = "unset";

    function StartPoint()  Ownable() public
    {

    }


     function setAddress(string _updatedIpfsAddress) external onlyOwner
     {
        myIpfsString = _updatedIpfsAddress;
    }

    function getAddress() public constant returns(string)
    {
        return myIpfsString;
    }
}
