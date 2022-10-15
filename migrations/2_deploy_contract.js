const ADP = artifacts.require("AdminUpgradeabilityProxy");
const TDC = artifacts.require("TDCNFT");

module.exports = async function (deployer) {
  await deployer.deploy(TDC);
  const impl = await TDC.deployed();
  console.log('Deployed', impl.address);
  const proxy = await deployer.deploy(ADP, impl.address, "0x5d9D2C5783E43486353ed112A49d6067042382b5");
  const res = await proxy.implementation();
  console.log(res);
};
