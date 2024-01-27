require("dotenv").config();

const Election = artifacts.require("Election");

// Switch the chairperson's address (in the .env file) to your first account in your Ganache environment
const addressChairperson = process.env.addressChairperson;

contract("The Election Contract", () => {
    it("should set the initial vote count to be 0", async () => {
        const electionInstance = await Election.deployed();
        const ballotCount = await electionInstance.ballotCount();
        assert.equal(ballotCount, 0, "The initial ballot count is not 0");
    });

    it("should set the correct chairperson", async () => {
        const electionInstance = await Election.deployed();
        const chairperson = await electionInstance.chairperson();
        assert.equal(chairperson, addressChairperson, "The chairperson's address is wrong");
    });
})