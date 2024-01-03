import 'package:async/async.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/token.dart';

class SignInUsecase {
  final IAuthService _authService;
  SignInUsecase(this._authService);
  Future<Result<Token>> execute() async {
    return await _authService.signIn();
  }
}
