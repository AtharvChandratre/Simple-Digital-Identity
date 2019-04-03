var Coin = artifacts.require("./digital_identity.sol");

module.exports = function(deployer) {
  deployer.deploy(Coin);
};

