import { ethers } from "hardhat";

async function main() {
  const tribeFactory = await ethers.deployContract("TribeFactory");

  await tribeFactory.waitForDeployment();
  console.log(tribeFactory);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// https://goerli.etherscan.io/address/0x6369e96054eb206c28291a39bce940cd894b4ae8
// npx hardhat verify --network goerli 0x6369e96054eb206c28291a39bce940cd894b4ae8
