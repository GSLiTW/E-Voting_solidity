// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.0;

contract Ballot{

    // Which should be set by the owner
    address public chairperson;

    //Which are changeable
    address[] public voting_machines;  //Address list of eligible voting machines.
    Vote[] public votes_array; //To store imcoming votes from the "send_vote" function
    mapping(string => string) public receipts;

    uint public vote_count;
    uint public voting_end_time;
    string public encryption_key;
    string public decryption_key;

    modifier voting_in_progress{
        require(block.timestamp <= voting_end_time, 'Voting has ended.');
        _;
    }

    modifier eligible_voting_machines{
        bool eligible = false;
        for(uint i = 0; i < voting_machines.length; i++){
            if(msg.sender == voting_machines[i]){
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

    struct Vote {
        string _encrypted_vote;
        string _signature;
    }

    /// Create a new ballot to vote until chairperson call end_voting()
    constructor()
        public
    {
        chairperson = msg.sender;
        vote_count = 0;
        voting_end_time = block.timestamp;
        encryption_key = '';
        decryption_key = '';
    }

    // Called by voting_machines to send vote
    function send_vote(string memory _encrypted_vote, string memory _signature)
        public
        voting_in_progress
        eligible_voting_machines
    {
        Vote memory new_vote = Vote(_encrypted_vote, _signature);
        votes_array.push(new_vote);
        vote_count += 1;
    }

    function reset_voting()
        public
        isChairperson
    {
        delete voting_machines;
        delete votes_array;
        vote_count = 0;
        voting_end_time = block.timestamp;
        encryption_key = '';
        decryption_key = '';
    }

    function end_voting()
        public
        isChairperson
    {
        voting_end_time = block.timestamp;
    }

    function start_voting(uint duration)
        public
        isChairperson
    {
        voting_end_time = block.timestamp + duration;
    }

    function set_eligible_voting_machine(address _addr)
        public
        isChairperson
    {   
        bool found = false;
        for(uint i=0; i<voting_machines.length; i++){
            if(voting_machines[i] == _addr){
                found == true;
                break;
            }
        }
        
        if(found == false){
            voting_machines.push(_addr);
        }
    }

    function send_voter_receipt(string memory _voter_receipt, string memory _encrypted_vote)
        public
        eligible_voting_machines
    {
        receipts[_voter_receipt] = _encrypted_vote;
    }

    function set_encryption_key(string memory _encryption_key)
        public
        isChairperson
    {
        encryption_key = _encryption_key;
    }

    function set_decryption_key(string memory _decryption_key)
        public
        isChairperson
    {
        decryption_key = _decryption_key;
    }
}