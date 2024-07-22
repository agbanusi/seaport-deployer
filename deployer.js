const { ethers } = require("hardhat");
require("dotenv");

async function main() {
  const networkUrl = process.env.RPC; //"https://testnet-rpc.plumenetwork.xyz/http"; // Zeta network URL
  const privateKey = process.env.PRIVATE_KEY; // Fetch private key from environment variable
  const provider = new ethers.providers.JsonRpcProvider(networkUrl);
  const deployer = new ethers.Wallet(privateKey, provider);

  // const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const seaportFactory = await ethers.getContractFactory("Seaport");

  // const conduitControllerFactory = await ethers.getContractFactory(
  //   "ConduitController"
  // );

  // const overrides = {
  //   gasLimit: 80000000, // Set the desired gas limit here
  //   gasPrice: 50000000000,
  // };

  // const conduitController = await conduitControllerFactory
  //   .connect(deployer)
  //   .deploy();

  // await conduitController.deployed();
  // const overrides = {
  //   gasLimit: 8000000, // Set the desired gas limit here
  //   gasPrice: 10000000,
  // };
  // console.log("conduit controller deployed to " + conduitController.address);

  const seaportContract = await seaportFactory
    .connect(deployer)
    .deploy("0x9B9c98f8D04FeA09e50953187F93b505D2539BE4");

  await seaportContract.deployed();

  console.log("seaport deployed to " + seaportContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
