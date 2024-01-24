// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.18;

contract Ballot{

    // Which should be set by the owner
    address public immutable chairperson;

    //Which are changeable
    address[] public votingMachines;  //Address list of eligible voting machines.
    Vote[] public votesArray; //To store imcoming votes from the "send_vote" function
    mapping(string => string) public receipts;

    uint public voteCount;
    uint public votingEndTime;
    string public encryptionKey;
    string public decryptionKey;

    modifier votingInProgress{
        require(block.timestamp <= votingEndTime, 'Voting has ended.');
        _;
    }

    modifier eligibleVotingMachines{
        bool eligible = false;
        uint array_length = votingMachines.length;
        for(uint i = 0; i < array_length; i++){
            if(msg.sender == votingMachines[i]){
                eligible = true;
                break;
            }
        }
        require(eligible, 'The machine is not in the eligible list.');
        _;
    }

    modifier isChairperson{
        require(msg.sender==chairperson, 'Sender is not the chairperson.');
        _;
    }

    struct Vote{
        string _encrypted_vote;
        string _signature;
    }

    /// Create a new ballot to vote until chairperson call end_voting()
    constructor(){
        chairperson = msg.sender;
        voteCount = 0;
        votingEndTime = block.timestamp;
        encryptionKey = '';
        decryptionKey = '';
    }

    // Called by voting_machines to send vote
    function sendVote(string memory newEncryptedVote, string memory newSignature)
        public
        votingInProgress
        eligibleVotingMachines
    {
        Vote memory new_vote = Vote(newEncryptedVote, newSignature);
        votesArray.push(new_vote);
        voteCount += 1;
    }

    function resetVoting()
        public
        isChairperson
    {
        delete votingMachines;
        delete votesArray;
        voteCount = 0;
        votingEndTime = block.timestamp;
        encryptionKey = '';
        decryptionKey = '';
    }

    function endVoting()
        public
        isChairperson
    {
        votingEndTime = block.timestamp;
    }

    function startVoting(uint duration)
        public
        isChairperson
    {
        votingEndTime = block.timestamp + duration;
    }

    function setEligibleVotingMachine(address newAddr)
        public
        isChairperson
    {   
        bool found = false;
        uint array_length = votingMachines.length;
        for(uint i=0; i<array_length; i++){
            if(votingMachines[i] == newAddr){
                found = true;
                break;
            }
        }
        
        if(!found){
            votingMachines.push(newAddr);
        }
    }

    function sendVoterReceipt(string memory voterReceipt, string memory newEncryptedVote)
        public
        eligibleVotingMachines
    {
        receipts[voterReceipt] = newEncryptedVote;
    }

    function setEncryptionKey(string memory newEncryptionKey)
        public
        isChairperson
    {
        encryptionKey = newEncryptionKey;
    }

    function setDecryptionKey(string memory newDecryptionKey)
        public
        isChairperson
    {
        decryptionKey = newDecryptionKey;
    }
}