import mongoose from "mongoose";
import AuthRepository from "../../../../src/auth/data/repository/AuthRepository";
import dotenv from "dotenv";
import { expect } from "chai";
dotenv.config();

describe("AuthRepository", () => {
  let client: mongoose.Mongoose;
  let sut: AuthRepository;
  beforeEach(async () => {
    client = new mongoose.Mongoose();

    const connectionStr = encodeURI(process.env.TEST_DB as string);
    await client.connect(connectionStr);
    sut = new AuthRepository(client);
  });
  afterEach(() => {
    client.disconnect();
  });
  it("should return user when email is found", async () => {
    //arrange
    const email = "mail@mail.com";
    //act
    const result = await sut.find(email);
    //assert
    expect(result).to.not.be.empty;
  });
  it("should return user id when added to db", async () => {
    //arrange
    const user = {
      name: "John Flyn",
      email: "Flyn@mail.com",

      password: "pass232",
      type: "email",
    };
    //act
    const result = await sut.add(
      user.name,
      user.email,
      user.type,
      user.password
    );
    //assert
    expect(result).to.not.be.empty;
  });
});
