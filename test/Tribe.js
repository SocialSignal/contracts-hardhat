const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deploy() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Tribe = await ethers.getContractFactory("Tribe");
    const tribe = await Tribe.deploy("Name", "Symbol");

    return { tribe, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      const { tribe, owner } = await loadFixture(deploy);
      
      expect(await tribe.owner()).to.equal(owner.address);
    });

    it("Accept owner", async function () {
      const { tribe, owner } = await loadFixture(deploy);

      await tribe.accept(owner.address)

      expect(await tribe.ownerAccepted(owner.address)).to.equal(true);
      expect(await tribe.memberAccepted(owner.address)).to.equal(true);
    });
  });
});
