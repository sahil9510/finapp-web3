const {ethers} = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main(){
  const investContract = await ethers.getContractFactory("Invest");
  const deployedInvestContract = await investContract.deploy();
  await deployedInvestContract.deployed();
  
  console.log("Invest Contract Address: ",deployedInvestContract.address)
}

main()
  .then(()=> process.exit(0))
  .catch((error)=>{
    console.error(error);
    process.exit(1);
})