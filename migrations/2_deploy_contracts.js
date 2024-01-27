var Election = artifacts.require("Election");
var VoterIdentities = artifacts.require("VoterIdentities");

module.exports = function(deployer) {
  deployer.deploy(Election);
  deployer.deploy(VoterIdentities);
};
