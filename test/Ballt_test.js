const Ballot = artifacts.require("Ballot");

const addrChairperson = "0xdE4FeA565ff271Aa3b66890B5d1420c7fc1b9EF5";

contract("The Ballot Contract", () => {
    it("should set the initial vote count to be 0", async () => {
        const ballotInstance = await Ballot.deployed();
        const voteCount = await ballotInstance.vote_count();
        assert.equal(voteCount, 0, "The initial vote count is not 0");
    });

    it("should set the correct chairperson", async () => {
        const ballotInstance = await Ballot.deployed();
        const chairperson = await ballotInstance.chairperson();
        assert.equal(chairperson, addrChairperson, "The chairperson's address is wrong");
    });
})