import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  MockClient? client;
  AuthApi? sut;
  setUp(() {
    registerFallbackValue(FakeUri());
    client = MockClient();
    sut = AuthApi("http:baseUrl", client!);
  });
  group('signin', () {
    final credential = Credential(
        type: AuthType.email, email: 'email@email', password: 'pass');
    test('should return error when status code is not 200', () async {
      //arrange
      when(() => client?.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{}', 404));
      //act
      final result = await sut!.signIn(credential);
      //assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when status code is 200 but malformed', () async {
      //arrange
      when(() => client?.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{}', 200));
      //act
      final result = await sut!.signIn(credential);
      //assert
      expect(result, isA<ErrorResult>());
    });
    test('should return token when successful', () async {
      //arrange
      var tokenStr = "Abbgs..";
      when(() => client?.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'auth_token': tokenStr}), 200));
      //act
      final result = await sut!.signIn(credential);
      //assert
      expect(result.asValue?.value, tokenStr);
    });
  });
  group('signup', () {
    final credential = Credential(
        type: AuthType.email, email: 'email@email', password: 'pass');
    test('should return error when status code is not 200', () async {
      //arrange
      when(() => client?.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{}', 404));
      //act
      final result = await sut!.signUp(credential);
      //assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when status code is 200 but malformed', () async {
      //arrange
      when(() => client?.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{}', 200));
      //act
      final result = await sut!.signUp(credential);
      //assert
      expect(result, isA<ErrorResult>());
    });
    test('should return token when successful', () async {
      //arrange
      var tokenStr = "Abbgs..";
      when(() => client?.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'auth_token': tokenStr}), 200));
      //act
      final result = await sut!.signUp(credential);
      //assert
      expect(result.asValue?.value, tokenStr);
    });
  });
}
