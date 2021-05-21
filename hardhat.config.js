require("@nomiclabs/hardhat-waffle");
require("dotenv").config({path: "./.env"});
const infuraKovan = process.env.INFURA_KOVAN;
const kovanPrivateKey = process.env.KOVAN_PRIVATE_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  networks: {
    hardhat: {
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${infuraKovan}`,
      accounts: [`0x${kovanPrivateKey}`]
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