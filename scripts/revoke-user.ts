import "dotenv/config";
import { ethers } from "ethers";

const { PK, RPC_URL } = process.env;
export const provider = new ethers.JsonRpcProvider(RPC_URL);

export const wallet = new ethers.Wallet(PK!, provider);

const tribeAbi = [
  "function accept(address account) external",
  "function revoke(address account) external",
];
export const tribe = new ethers.Contract(
  "0x07d25b48405ab90b61717c0cf710aa4df2d108a4",
  tribeAbi,
  wallet
);

tribe.revoke(wallet.address);
