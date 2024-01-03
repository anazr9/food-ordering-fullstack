// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdaper {
  void onAuthSuccess(BuildContext context, IAuthService authService);
}

class AuthPageAdapter implements IAuthPageAdaper {
  final Widget Function(IAuthService authService) onUserAuthenticated;
  AuthPageAdapter({
    required this.onUserAuthenticated,
  });
  @override
  void onAuthSuccess(BuildContext context, IAuthService authService) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => onUserAuthenticated(authService),
        ),
        (route) => false);
  }
}
