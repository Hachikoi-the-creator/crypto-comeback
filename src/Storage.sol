// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/* Make possible for users to store name alongside their favourite number
*/
import "./SharedStructs.sol";

contract Storage {
    mapping (address userAdx => SharedStructs.UserData) /*public*/ addresToUser;

    function getUser(address _userAdx) view  public returns (SharedStructs.UserData memory){
        return addresToUser[_userAdx];
    }

    function setUserData(address userAdx, string calldata username, uint16 _favNum) public {
        SharedStructs.UserData memory newUser = SharedStructs.UserData({favNum: _favNum, nickname:username});
        addresToUser[userAdx] = newUser;
    }
}