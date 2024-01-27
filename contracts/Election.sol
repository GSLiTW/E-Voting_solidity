// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.18;

contract Election{
    address public immutable chairperson;

    Ballot[] public castBallots;
    mapping(address => bool) public validVotingMachines;
    mapping(string => uint) public identifierToBallotIndex;
    uint public ballotCount;
    uint public votingEndTime;

    struct Ballot{
        string vote;
        string uniqueIdentifier; // Generated offchain
    }

    modifier isDuringVoting{
        require(block.timestamp <= votingEndTime, 'Voting has ended.');
        _;
    }

    modifier isValidVotingMachine{
        bool valid = (validVotingMachines[msg.sender]) ? true : false;
        require(valid, 'The voting machine is not valid.');
        _;
    }

    modifier isChairperson{
        require(msg.sender==chairperson, 'The sender is not the chairperson.');
        _;
    }

    constructor(){
        chairperson = msg.sender;
        ballotCount = 0;
        votingEndTime = block.timestamp + 8 hours;
    }

    function submitVote(string calldata vote, string calldata uniqueIdentifier)
        public
        isDuringVoting
        isValidVotingMachine
    {
        Ballot memory newBallot = Ballot(vote, uniqueIdentifier);
        castBallots.push(newBallot);
        identifierToBallotIndex[uniqueIdentifier] = ballotCount; // Store the index of the ballot in the array to a mapping
        ballotCount += 1;
    }

    function submitVoteMultiple(string[] calldata voteArray, string[] calldata uniqueIdentifierArray, uint submitBallotCount)
        public
        isDuringVoting
        isValidVotingMachine
    {   
        for(uint i = 0; i < submitBallotCount; i++){
            Ballot memory newBallot = Ballot(voteArray[i], uniqueIdentifierArray[i]);
            castBallots.push(newBallot);
            identifierToBallotIndex[uniqueIdentifierArray[i]] = ballotCount; // Store the index of the ballot in the array to a mapping
            ballotCount += 1;
        }
    }

    function resetVoting()
        public
        isChairperson
    {
        delete castBallots;
        ballotCount = 0;
        votingEndTime = block.timestamp + 8 hours;
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

    function setValidVotingMachine(address machineAddress)
        public
        isChairperson
    {   
        validVotingMachines[machineAddress] = true;
    }

    function tally()
        public
        view
        returns(Ballot[] memory)
    {
        // return all cast ballots (i.e., you should do the vote counting offchain)
        return castBallots;
    }
}