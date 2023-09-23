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

    it("Accept member (owner -> member)", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(true);
    });

    it("Accept member (member -> owner)", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(false);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(true);

      await tribe.connect(owner).accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
    });

    it("Revert if not owner or member", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await expect(tribe.connect(otherAccount).accept(owner.address)).to.be.revertedWith('msg.sender needs to be equal to member or owner');
    });

    it("Accept and revoke member by member", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(false);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(true);

      await tribe.connect(otherAccount).revoke(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(false);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);
    });

    it("Accept and revoke member by owner", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);

      await tribe.revoke(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(false);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);
    });

    it("Join tribe - from member", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);

      await tribe.connect(otherAccount).join(otherAccount.address);
      expect(await tribe.isMember(otherAccount.address)).to.equal(true);
    });

    it("Reverts Join tribe - only member approve", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);

      await expect(tribe.join(otherAccount.address)).to.be.revertedWith('You are not allowed to mint this token');
    });

    it("Join tribe - from owner", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).join(otherAccount.address);

      expect(await tribe.isMember(otherAccount.address)).to.equal(true);
    });

    it("Reverts Join tribe - only owner approve", async function () {
      const { tribe, otherAccount } = await loadFixture(deploy);

      await tribe.accept(otherAccount.address);
      expect(await tribe.ownerAccepted(otherAccount.address)).to.equal(true);
      expect(await tribe.memberAccepted(otherAccount.address)).to.equal(false);

      await expect(tribe.join(otherAccount.address)).to.be.revertedWith('You are not allowed to mint this token');
    });
  });
});
