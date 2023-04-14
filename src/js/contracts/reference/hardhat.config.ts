import * as dotenv from 'dotenv';

import {HardhatUserConfig} from 'hardhat/config';
import 'hardhat-deploy';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-waffle';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'solidity-coverage';

import {mnemonic, mainnetMnemonic} from './mnemonics';

dotenv.config();

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: '0.8.14',
        settings: {
          viaIR: true,
          optimizer: {
            enabled: true,
            runs: 19066
          }
        }
      }
    ]
  },
  namedAccounts: {
    deployer: 0,
    alice: 1,
    bob: 2,
    charlie: 3,
    drew: 4
  },

  networks: {
    hardhat: {
      saveDeployments: true,
      chainId: 1337,
      accounts: {
        mnemonic
      },
      forking: {
        url: 'https://eth-mainnet.alchemyapi.io/v2/HTJg7UON9Axg5HDnRcUavxD2CaXCZnmv'
      }
    },
    mainnet: {
      url: 'https://eth-mainnet.alchemyapi.io/v2/HTJg7UON9Axg5HDnRcUavxD2CaXCZnmv',
      // url: 'https://mainnet.infura.io/v3/a1f1a6ef150f4c25996cc3c45314c03f',
      accounts: {
        mnemonic: mainnetMnemonic || mnemonic
      },
      live: true,
      saveDeployments: true
    },
    kovan: {
      url: 'https://kovan.infura.io/v3/a1f1a6ef150f4c25996cc3c45314c03f',
      accounts: {
        mnemonic
      },
      live: true,
      saveDeployments: true,
      tags: ['staging']
    },
    polygonMumbai: {
      url: 'https://polygon-mumbai.g.alchemy.com/v2/HTJg7UON9Axg5HDnRcUavxD2CaXCZnmv',
      accounts: {
        mnemonic
      },
      live: true,
      saveDeployments: true,
      tags: ['staging']
    },
    rinkeby: {
      url: 'https://rinkeby.infura.io/v3/a1f1a6ef150f4c25996cc3c45314c03f',
      accounts: {
        mnemonic
      },
      live: true,
      saveDeployments: true,
      tags: ['staging']
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: 'USD',
    coinmarketcap: process.env.CMC_API_KEY
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  typechain: {
    target: 'ethers-v5',
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ['./node_modules/@openzeppelin/contracts-upgradeable/build/contracts*.json', './node_modules/@openzeppelin/contracts/build/contracts*.json'] // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
  }
};

export default config;
