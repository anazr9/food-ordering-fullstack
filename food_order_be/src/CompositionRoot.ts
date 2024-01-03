import mongoose from "mongoose";
import AuthRepository from "./auth/data/repository/AuthRepository";
import JwtTokenService from "./auth/data/services/JwtTokenService";
import BcryptPasswordService from "./auth/data/services/BcryptPasswordService";
import AuthRouter from "./auth/entrypoint/AuthRouter";
import redis from "redis";
import RedisTokenStore from "./auth/data/services/RedisTokenStore";
import TokenValidator from "./auth/helpers/TokenValidator";
import RestaurantRepository from "./restaurant/data/repository/RestaurantRepositoryImpl";
import RestaurantRouter from "./restaurant/entrypoint/RestaurantRouter";

export default class CompositionRoot {
  private static client: mongoose.Mongoose;
  private static redisClient: redis.RedisClient;

  public static async configure() {
    this.client = new mongoose.Mongoose();
    this.redisClient = redis.createClient();
    // await this.redisClient.connect();
    const connectionStr = encodeURI(process.env.DEV_DB as string);
    this.client.connect(connectionStr);
  }
  public static authRouter() {
    const repository = new AuthRepository(this.client);
    const tokenService = new JwtTokenService(process.env.PRIVATE_KEY as string);
    const passwordService = new BcryptPasswordService();
    const tokenStore = new RedisTokenStore(this.redisClient);
    const tokenValidator = new TokenValidator(tokenService, tokenStore);
    return AuthRouter.configure(
      repository,
      tokenService,
      tokenStore,
      passwordService,
      tokenValidator
    );
  }
  public static restaurantRouter() {
    const repository = new RestaurantRepository(this.client);
    const tokenService = new JwtTokenService(process.env.PRIVATE_KEY as string);
    const tokenStore = new RedisTokenStore(this.redisClient);
    const tokenValidator = new TokenValidator(tokenService, tokenStore);
    return RestaurantRouter.configure(repository, tokenValidator);
  }
}
