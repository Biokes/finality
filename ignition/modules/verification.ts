import hre from "hardhat";
import { verifyContract } from "@nomicfoundation/hardhat-verify/verify";

await verifyContract(
  {
    address: "",
    provider: "etherscan",
  },
  hre,
);
