import { ethers } from "hardhat";
import { TribeFactory } from "../typechain-types";

async function main() {
  let tribeFactory: TribeFactory;
  const TribeFactory = await ethers.getContractFactory("TribeFactory");
  tribeFactory = TribeFactory.attach(
    "0x6369E96054eB206C28291A39bcE940Cd894B4Ae8"
  ) as any;
  const tx = await tribeFactory.createTribe(
    "0x2a4fc9c5ec629d872f82d29fae5dfa71b39b7e28",
    "testing.com",
    "tribes.eth",
    "Tribe",
    "TRB"
  );
  console.log(tx);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// https://goerli.etherscan.io/address/0x07d25b48405ab90b61717c0cf710aa4df2d108a4#code
// npx hardhat verify --network goerli 0x07d25b48405ab90b61717c0cf710aa4df2d108a4 "0x2a4fc9c5ec629d872f82d29fae5dfa71b39b7e28" "testing.com" "tribes.eth" "Tribe" "TRB"
