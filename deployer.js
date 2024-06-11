const { ethers } = require("hardhat");
require("dotenv");

async function main() {
  const networkUrl = process.env.RPC; //"https://testnet-rpc.plumenetwork.xyz/http"; // Zeta network URL
  const privateKey = process.env.PRIVATE_KEY; // Fetch private key from environment variable
  const provider = new ethers.providers.JsonRpcProvider(networkUrl);
  const deployer = new ethers.Wallet(privateKey, provider);

  // const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address,
    networkUrl
  );

  const seaportFactory = await ethers.getContractFactory("OtcTokenFactory");

  // const conduitControllerFactory = await ethers.getContractFactory(
  //   "ConduitController"
  // );

  // const conduitController = await conduitControllerFactory
  //   .connect(deployer)
  //   .deploy();

  // await conduitController.deployed();
  // const overrides = {
  //   gasLimit: 6000000, // Set the desired gas limit here
  //   gasPrice: 10000000,
  // };

  // console.log(seaportFactory);

  const seaportContract = await seaportFactory.connect(deployer).deploy({
    gasLimit: 4200000,
    gasPrice: 20000000,
  });

  // console.log(seaportContract);

  await seaportContract.deployed();

  // const otcContract = await seaportContract.createToken(
  //   "test token",
  //   "otc",
  //   deployer.address
  // );

  // await otcContract.();

  console.log("seaport deployed to " + seaportContract.address);
  // console.log("seaport deployed to " + otcContract.address);
  // console.log("conduit controller deployed to " + conduitController.address);
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
