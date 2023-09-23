require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

const gwei = 1000000000;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.21",
        settings: {
          optimizer: { enabled: true, runs: 200 },
          evmVersion: "london"
        },
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
        url: `https://goerli.infura.io/v3/${process.env.INFURA_KEY}`, 
      }
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN
  },
};