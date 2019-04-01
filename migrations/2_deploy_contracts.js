var digital_Identity = artifacts.require("./digital_Identity.sol");

module.exports = function(deployer) {
  deployer.deploy(digital_Identity);
};

