const { expect } = require("chai");

describe("Tribe", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deploy() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Tribe = await ethers.getContractFactory("Tribe");
    const tribe = await Tribe.deploy()
    await tribe.initialize(owner.address, "https://example.com/", "socialsignal");

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
      await tribe.connect(otherAccount).accept(otherAccount.address);

      expect(await tribe.isMember(otherAccount.address)).to.equal(true);
    });

    it("Join tribe - from owner", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).accept(otherAccount.address);

      expect(await tribe.isMember(otherAccount.address)).to.equal(true);
    });

    it("Reverts with max mint per wallet", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).accept(otherAccount.address);

      expect(await tribe.isMember(otherAccount.address)).to.equal(true);
      await expect(tribe.connect(owner).accept(otherAccount.address)).to.be.revertedWith('Value already set');
    });

    it("Exits tribe - from owner", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).accept(otherAccount.address);

      expect(await tribe.isMember(otherAccount.address)).to.equal(true);

      await tribe.connect(owner).revoke(otherAccount.address);
      expect(await tribe.isMember(otherAccount.address)).to.equal(false);
    });

    it("Reads NFT metadata", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).accept(otherAccount.address);

      expect(await tribe.tokenURI(1)).to.equal("https://example.com/");
    });

    it("Transfer should not work", async function () {
      const { tribe, owner, otherAccount } = await loadFixture(deploy);

      await tribe.connect(otherAccount).accept(otherAccount.address);
      await tribe.connect(owner).accept(otherAccount.address);

      await tribe.connect(otherAccount).approve(owner.address, 1);
      await tribe.connect(otherAccount).transferFrom(otherAccount.address, owner.address, 1);

      expect(await tribe.balanceOf(otherAccount)).to.equal(1);
    });
  });
});
