// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const tribe = await hre.ethers.deployContract("Tribe");

  await tribe.waitForDeployment();

  const tribeAddress = tribe.target;

  console.log(
    `Tribe deployed to ${tribeAddress}`
  );

  const tribeFactory = await hre.ethers.deployContract("TribeFactory", [tribeAddress]);

  await tribeFactory.waitForDeployment();

  console.log(
    `TribeFactory deployed to ${tribeFactory.target}`
  );

  await tribe.transferOwnership(tribeFactory.target);

  console.log("Tribe ownership transferred to TribeFactory");

  // Time sleep for 30 
  await new Promise(r => setTimeout(r, 30000));

  await hre.run("verify:verify", {
    address: tribe.target,
  });

  await hre.run("verify:verify", {
    address: tribeFactory.target,
    constructorArguments: [tribe.address],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
