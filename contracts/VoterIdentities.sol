// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {OwnerHelpers} from "./helpers/OwnerHelpers.sol";

contract VoterIdentities is OwnerHelpers{
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address public immutable chairperson;

    voterCredential[] public credentials;
    mapping(address => bool) public eligibleVoters; // Preregistered eligible voters' address
    uint public credentialCount;

    struct voterCredential{ // Credentials is voters' signatures (for now)
        bytes32 message;
        bytes signature;
    }

    constructor(){
        chairperson = msg.sender;
    }

    function submitCredentials(voterCredential calldata uploadedCredential)
        public
    {
        bool result = verifyCredentials(uploadedCredential);
        require(result);
        credentials.push(uploadedCredential);
        credentialCount += 1;
    }

    function verifyCredentials(voterCredential calldata uploadedCredential)
        internal
        view
        returns (bool)
    {   
        bytes32 message = uploadedCredential.message;
        bytes memory signature = uploadedCredential.signature;
        return eligibleVoters[message.toEthSignedMessageHash().recover(signature)]; // if the voter's address is in the list, pass!
    }

    function setEligibleVoters(address newVoterAddr)
        public
        isChairperson(chairperson)
    {   
        eligibleVoters[newVoterAddr] = true;
    }

    function returnAllCredentials()
        public
        view
        returns(voterCredential[] memory, uint)
    {   
        // You could do the credential checking offchain again
        return (credentials, credentialCount);
    }
}