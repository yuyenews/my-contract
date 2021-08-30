const Migrations = artifacts.require("Migrations");
const YYContract = artifacts.require("YYContract");
module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(YYContract, 100000000, 'CCCOIN', 'CC');
};
