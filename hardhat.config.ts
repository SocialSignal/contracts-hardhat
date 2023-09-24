import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import "dotenv/config";

const { PK, RPC_URL, ETHERSCAN_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    goerli: {
      url: RPC_URL,
      accounts: [PK!],
    },
  },
  etherscan: {
    apiKey: {
      goerli: ETHERSCAN_API_KEY!,
    },
  },
};

export default config;
