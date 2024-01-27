import dotenv from 'dotenv';
dotenv.config();

import{
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

// Specify the chairperson's address (in the .env file)
const addressChairperson = process.env.ADDR_CHAIRPERSON;

describe("Election", function () {
    async function deployFixture() {
      const [owner, otherAccount] = await ethers.getSigners();
  
      const Election = await ethers.getContractFactory("Election");
      const electionContract = await Election.deploy();
  
      return { electionContract, owner, otherAccount };
    }

    describe("Deployment", function () {
      it("Should record the right chairperson", async function () {
        const { electionContract } = await loadFixture(deployFixture);
        expect(await electionContract.chairperson()).to.equal(addressChairperson);
      });
    });
});
