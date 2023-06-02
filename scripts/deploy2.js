const {ethers} = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main(){
  const walletContract = await ethers.getContractFactory("Wallet");
  const deployedWalletContract = await walletContract.deploy("0xE82362AAbA58088EcCb554b195D5bc7D95d3e2DA","0xB5924c0F0Fd6a74127eC5D6f80c2e4f344c8b5Ce");
  await deployedWalletContract.deployed();
  
  console.log("Wallet Contract Address: ",deployedWalletContract.address)
}

main()
  .then(()=> process.exit(0))
  .catch((error)=>{
    console.error(error);
    process.exit(1);
})