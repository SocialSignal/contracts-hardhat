import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Tribe", function () {
  async function normal() {
    const [deployer, owner, user] = await ethers.getSigners();

    const Tribe = await ethers.getContractFactory("Tribe");
    const tribe = await Tribe.deploy(owner, "URL", "tribe.eth", "Tribe", "TRB");
    return { tribe, deployer, owner, user };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { tribe, owner } = await loadFixture(normal);

      expect(await tribe.owner()).to.equal(owner.address);
    });
  });

  describe("Join tribe", function () {
    describe("Validations", function () {
      it("Should mint NFT to new tribe member", async function () {
        const { tribe, owner, user } = await loadFixture(normal);

        const initialUserStatus = await tribe.getUserStatus(user.address);

        console.log(initialUserStatus);
        await tribe.connect(owner).accept(user);

        const userStatusAfterInvitation = await tribe.getUserStatus(
          user.address
        );
        await expect(tribe.connect(user).accept(user)).to.emit(
          tribe,
          "UserStatusUpdate"
        );
        expect(await tribe.balanceOf(user)).to.be.equal(1);
        console.log(userStatusAfterInvitation);
      });
    });
  });
});
