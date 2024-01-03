import * as express from "express";
import IAuthRepository from "../domain/IAuthRepository";
import ITokenService from "../services/ITokenService";
import IPasswordService from "../services/IPasswordService";
import AuthController from "./AuthController";
import SignInUseCase from "../usecases/SignInUseCase";
import SignUpUseCase from "../usecases/SignUpUseCase";
import {
  signinValidationRules,
  signupValidationRules,
  validate,
} from "../helpers/Validators";
import ITokenStore from "../services/ITokenStore";
import SignOutUseCase from "../usecases/SignOutUsecase";
import TokenValidator from "../helpers/TokenValidator";
export default class AuthRouter {
  public static configure(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    tokenStore: ITokenStore,
    passwordService: IPasswordService,
    tokenValidator: TokenValidator
  ): express.Router {
    const router = express.Router();
    let controller = AuthRouter.composeController(
      authRepository,
      tokenService,
      tokenStore,
      passwordService
    );
    router.post(
      "/signin",
      signinValidationRules(),
      validate,
      (req: express.Request, res: express.Response) =>
        controller.signin(req, res)
    );
    router.post(
      "/signup",
      signupValidationRules(),
      validate,
      (req: express.Request, res: express.Response) =>
        controller.signup(req, res)
    );
    router.post(
      "/signout",
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req: express.Request, res: express.Response) =>
        controller.signout(req, res)
    );
    return router;
  }
  private static composeController(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    tokenStore: ITokenStore,
    passwordService: IPasswordService
  ): AuthController {
    const signInUseCase = new SignInUseCase(authRepository, passwordService);
    const signUpUseCase = new SignUpUseCase(authRepository, passwordService);
    const signOutUseCase = new SignOutUseCase(tokenStore);
    const controller = new AuthController(
      signInUseCase,
      signUpUseCase,
      signOutUseCase,
      tokenService
    );
    return controller;
  }
}
