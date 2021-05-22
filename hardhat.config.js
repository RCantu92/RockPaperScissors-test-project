require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("hardhat-deploy-ethers");
require("dotenv").config({path: "./.env"});
const infuraKovan = process.env.INFURA_KOVAN;
const kovanPrivateKeyOne = process.env.KOVAN_PRIVATE_KEY_01;
const kovanPrivateKeyTwo = process.env.KOVAN_PRIVATE_KEY_02;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  networks: {
    hardhat: {
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${infuraKovan}`,
      accounts: [`0x${kovanPrivateKeyOne}`, `0x${kovanPrivateKeyTwo}`]
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.4"
      },
      {
        version: "0.8.0"
      }
    ]
  }
};