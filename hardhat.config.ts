import { defineConfig } from "hardhat/config";
import hardhatIgnitionEthers from "@nomicfoundation/hardhat-ignition-ethers";

export default defineConfig({
  plugins: [hardhatIgnitionEthers],

  solidity: {
    version: "0.8.28",
  },

  networks: {
    localhost: {
      type: "http",
      url: "http://127.0.0.1:8545",
    },
  },
});