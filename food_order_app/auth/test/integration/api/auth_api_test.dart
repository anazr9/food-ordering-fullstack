import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  http.Client client;
  AuthApi? sut;
  String baseUrl = 'http://localhost:3000';
  setUp(() {
    client = http.Client();
    sut = AuthApi(baseUrl, client);
  });
  final credential = Credential(
      type: AuthType.email,
      // name: "new user",
      email: 'newuser@email.com',
      password: "pass123");
  group('signin', () {
    test('should return json web token when successfull', () async {
      //arrange

      //act
      final result = await sut?.signIn(credential);
      //assert
      expect(result?.asValue?.value, isNotEmpty);
    });
  });
  group('signout', () {
    test('should sign out user and return true ', () async {
      //arrange
      final tokenStr = await sut?.signIn(credential);
      var token = Token(tokenStr?.asValue?.value);
      //act
      final result = await sut?.signOut(token);
      //assert
      expect(result?.asValue?.value, true);
    });
  });
}
