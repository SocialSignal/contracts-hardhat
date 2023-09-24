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
    },
    celo: {
      url: `https://celo-alfajores.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },  
    },
    neonevm: {
      url: `https://proxy.devnet.neonlabs.org/solana`,
      chainId: 245022926,
      allowUnlimitedContractSize: false,
      gas: "auto",
      gasPrice: "auto",
      isFork: true,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },  
    },
    mantle: {
      url: `https://rpc.testnet.mantle.xyz`,
      accounts: {
        mnemonic: process.env.MNEMONIC
      },  
    },
    gnosis: {
      url: "https://rpc.gnosischain.com",
      accounts: {
        mnemonic: process.env.MNEMONIC
      },  
    }
  },
  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_GOERLI,
      scroll: process.env.ETHERSCAN_SCROLL_SEPOLIA,
      linea: process.env.ETHERSCAN_LINEA_GOERLI,
      celo: process.env.ETHERSCAN_CELO_ALFAJORES,
      neonevm: "test",
      gnosis: process.env.ETHERSCAN_GNOSIS
    },
    customChains: [
      {
        network: "mantle",
        chainId: 5001,
        urls: {
          apiURL: "https://testnet.api.mantlescan.org/api",
          browserURL: "https://testnet.mantlescan.org/"
        },
      },
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
      },
      {
        network: "celo",
        chainId: 44787,
        urls: {
          apiURL: "https://api-alfajores.celoscan.io/api",
          browserURL: "https://alfajores.celoscan.io/"
        }
      },
      {
        network: "neonevm",
        chainId: 245022926,
        urls: {
          apiURL: "https://devnet-api.neonscan.org/hardhat/verify",
          browserURL: "https://devnet.neonscan.org"
      },
    }
    ]
  },
};