const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
  describe("Tribe", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deploy() {
      const [_, otherAccount] = await ethers.getSigners();

      const TribeFactory = await ethers.getContractFactory("TribeFactory");
      const tribeFactory = await TribeFactory.deploy();

      const Tribe = await ethers.getContractFactory("Tribe");
      const tribe = await Tribe.deploy();
      
      await tribeFactory.initialize(tribe.target);
  
      return { tribeFactory, otherAccount };
    }
  
    describe("Deployment", function () {
      it("Create tribe through Factory", async function () {
        const { tribeFactory, otherAccount } = await loadFixture(deploy);

        await tribeFactory.connect(otherAccount).createTribe(otherAccount.address, "https://example.com/", "socialsignal");
      });
    });
  });
  