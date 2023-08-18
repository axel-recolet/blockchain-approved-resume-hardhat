import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { AddressLike } from "ethers";
import { ethers } from "hardhat";
import { expect } from "chai";
import { faker } from "@faker-js/faker";

describe("Exerience", () => {
  async function deployExperienceFixture() {
    const [employee, employer, other] = await ethers.getSigners();

    const startedAt = faker.date.past().getUTCMilliseconds();
    const endedAt = faker.date
      .future({ refDate: startedAt })
      .getUTCMilliseconds();
    const skills = Array.from({ length: 3 }, () => faker.person.jobType());
    const description = faker.lorem.paragraph();

    const Experience = await ethers.getContractFactory("Experience");
    const experience = await Experience.deploy(
      employer,
      startedAt,
      endedAt,
      skills,
      description
    );

    return {
      experience,
      employee,
      employer,
      other,
      startedAt,
      endedAt,
      skills,
      description,
    };
  }

  describe("Deployement", () => {
    it("should set state", async () => {
      const {
        experience,
        employee,
        employer,
        skills,
        description,
        startedAt,
        endedAt,
      } = await loadFixture(deployExperienceFixture);

      expect(await experience.employee()).to.equal(employee.address);
      expect(await experience.employer()).to.equal(employer.address);
      expect(await experience.startedAt()).to.equal(startedAt);
      expect(await experience.endedAt()).to.equal(endedAt);
      expect(
        await Promise.all(
          Array.from({ length: 3 }, (v, k) => experience.skills(k))
        )
      ).to.include.members(skills);

      expect(await experience.description()).to.equal(description);
    });

    describe("Approve", () => {
      it("should revert if called by anyone else than employer", async () => {
        const { experience, employee, other } = await loadFixture(
          deployExperienceFixture
        );

        const revertContainExpected = "You aren't the employer.";

        await expect(experience.connect(employee).approve()).to.be.revertedWith(
          revertContainExpected
        );
        await expect(experience.connect(other).approve()).to.be.revertedWith(
          revertContainExpected
        );
      });

      it("should approved the experience when employer call it", async () => {
        const { experience, employer } = await loadFixture(
          deployExperienceFixture
        );

        await expect(experience.connect(employer).approve()).not.to.be.reverted;
        expect(await experience.isApproved()).to.be.true;
      });
    });
  });
});
