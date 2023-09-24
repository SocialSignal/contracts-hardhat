// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const tribeFactory = await hre.ethers.deployContract("TribeFactory");

  await tribeFactory.waitForDeployment();

  console.log(
    `TribeFactory deployed to ${tribeFactory.target}`
  );

  const tribe = await hre.ethers.deployContract("Tribe", [factory.address]);

  await tribe.waitForDeployment();

  const tribeAddress = tribe.target;

  console.log(
    `Tribe deployed to ${tribeAddress}`
  );

  await tribeFactory.setImplementation(tribe.target);

  console.log("Tribe ownership transferred to TribeFactory");

  // Time sleep for 30 
  await new Promise(r => setTimeout(r, 30000));

  await hre.run("verify:verify", {
    address: tribe.target,
    constructorArguments: [tribeFactory.target],
  });

  await hre.run("verify:verify", {
    address: tribeFactory.target,
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Membership {

    mapping(address => bool) public ownerApprove;
    mapping(address => bool) public memberApprove;

    constructor() {
        // Initialize the contract, you can set initial states here if needed
    }

    function setStateForOwner(address _address, bool _approved) public {
        // Here, you can add additional checks to confirm that the caller has the right to set the state
        ownerApprove[_address] = _approved;
    }

    function setStateForMember(address _address, bool _approved) public {
        // Here, you can add additional checks to confirm that the caller has the right to set the state
        memberApprove[_address] = _approved;
    }

    function getState(address _address) public view returns(State) {
        bool isOwnerApproved = ownerApprove[_address];
        bool isMemberApproved = memberApprove[_address];

        // If both owner and member have approved
        if (isOwnerApproved && isMemberApproved) {
            return State.Member;
        }

        // If only the owner has approved
        if (isOwnerApproved && !isMemberApproved) {
            return State.Invited;
        }

        // If only the member has approved
        if
