const Migrations = artifacts.require("Migrations");
const YYContract = artifacts.require("MyContract");
module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(YYContract, 100000000, 'BTCC', 'BTCC');
};
