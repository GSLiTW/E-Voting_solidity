// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract OwnerHelpers {
    modifier isChairperson(address chairperson){
        require(msg.sender==chairperson, 'The sender is not the chairperson.');
        _;
    }
}