import type { HardhatUserConfig } from "hardhat/config";
import hardhatVerify from "@nomicfoundation/hardhat-verify";
import hardhatKeystore from "@nomicfoundation/hardhat-Keystore";
import hardhatToolboxMochaEthersPlugin from "@nomicfoundation/hardhat-toolbox-mocha-ethers";
import { configVariable } from "hardhat/config";

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxMochaEthersPlugin, hardhatVerify, hardhatKeystore],
  solidity: {
    profiles: {
      default: {
        version: "0.8.28",
      },
      production: {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          viaIR: true,
        },
      },
    },
  },
  networks: {
    liskSepolia: {
      type: "http",
      url:configVariable("LISK_SEPOLIA_URL"),
      accounts: [configVariable("PRIVATE_KEY")],
      chainId: 4202,
    },
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    // lisksepolia: {
    //   type: "http",
    //   chainType: "l1",
    //   url: configVariable("LISK_SEPOLIA_URL"),
    //   accounts: [configVariable("PRIVATE_KEY")],
    // },
  },
  verify: {
    etherscan: {
      apiKey: configVariable("ETHERSCAN_API_KEY"),
    },
     blockscout: {
      enabled: true,
    }
  },
    chainDescriptors: {
    4202: {
      name: "Listk Sepolia Blockscout",
      blockExplorers: {
        blockscout: {
          name: "Lisk Sepolia Blockscout",
          url: "https://rpc.sepolia-api.lisk.com",
          apiUrl: "https://sepolia-blockscout.lisk.com/api",
        },
        etherscan: {
          name: "Lisk Sepolia Blockscout",
          url: "https://rpc.sepolia-api.lisk.com",
          apiUrl: "https://sepolia-blockscout.lisk.com/api",
        },
      },
    },
  },
};

export default config;
