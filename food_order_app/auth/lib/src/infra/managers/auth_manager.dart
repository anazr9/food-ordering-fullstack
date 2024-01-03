import 'package:auth/auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';

class AuthManager {
  IAuthApi? _api;
  AuthManager(IAuthApi api) {
    _api = api;
  }
  IAuthService service(AuthType type) {
    IAuthService service;
    switch (type) {
      case AuthType.google:
        service = GoogleAuth(_api!);
        break;
      case AuthType.email:
        service = EmailAuth(_api!);
        break;
    }
    return service;
  }
  // IAuthService get google => GoogleAuth(_api!);
  // IAuthService email({
  //   required String email,
  //   required String password,
  // }) {
  //   final emailAuth = EmailAuth(_api!);
  //   emailAuth.credential(email: email, password: password);
  //   return emailAuth;
  // }
}
