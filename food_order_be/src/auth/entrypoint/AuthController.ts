import ITokenService from "../services/ITokenService";
import SignInUseCase from "../usecases/SignInUseCase";
import * as express from "express";
import SignUpUseCase from "../usecases/SignUpUseCase";
import SignOutUserCase from "../usecases/SignOutUsecase";

export default class AuthController {
  private readonly signInUseCase: SignInUseCase;
  private readonly signUpUseCase: SignUpUseCase;
  private readonly signOutUseCase: SignOutUserCase;
  private readonly tokenService: ITokenService;
  constructor(
    signInUseCase: SignInUseCase,
    signUpUseCase: SignUpUseCase,
    signOutUseCase: SignOutUserCase,
    tokenService: ITokenService
  ) {
    this.signInUseCase = signInUseCase;
    this.signUpUseCase = signUpUseCase;
    this.signOutUseCase = signOutUseCase;
    this.tokenService = tokenService;
  }
  public async signin(req: express.Request, res: express.Response) {
    try {
      const { name, auth_type, email, password } = req.body;
      return this.signInUseCase
        .execute(name, email, password, auth_type)
        .then((id: string) =>
          res.status(200).json({ auth_token: this.tokenService.encode(id) })
        )
        .catch((err: Error) => res.status(404).json({ error: err.message }));
    } catch (err) {
      return res.status(400).json({ error: err });
    }
  }
  public async signup(req: express.Request, res: express.Response) {
    try {
      const { name, auth_type, email, password } = req.body;
      return this.signUpUseCase
        .execute(name, auth_type, email, password)
        .then((id: string) =>
          res.status(200).json({ auth_token: this.tokenService.encode(id) })
        )
        .catch((err: Error) => res.status(404).json({ error: err.message }));
    } catch (err) {
      return res.status(400).json({ error: err });
    }
  }
  public async signout(req: express.Request, res: express.Response) {
    try {
      const token = req.headers.authorization!;
      return this.signOutUseCase
        .execute(token)
        .then((result) => res.status(200).json({ message: result }))
        .catch((err: Error) => res.status(404).json({ error: err.message }));
    } catch (err) {
      return res.status(400).json({ error: err });
    }
  }
}
