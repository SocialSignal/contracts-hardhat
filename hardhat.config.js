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
    },
    scroll: {
      url: `https://bold-evocative-arrow.scroll-testnet.quiknode.pro/${process.env.QUICKNODE_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },
    },
    linea: {
      url: `https://linea-goerli.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },  
    }
  },
  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_GOERLI,
      scroll: process.env.ETHERSCAN_SCROLL_SEPOLIA,
      linea: process.env.ETHERSCAN_LINEA_GOERLI
    },
    customChains: [
      {
        network: "scroll",
        chainId: 534351,
        urls: {
          apiURL: "https://api-sepolia.scrollscan.dev/api",
          browserURL: "https://sepolia.scrollscan.dev/"
        }
      },
      {
        network: "linea",
        chainId: 59140,
        urls: {
          apiURL: "https://api-testnet.lineascan.build/api",
          browserURL: "https://goerli.lineascan.build/"
        }
      }
    ]
  },
};