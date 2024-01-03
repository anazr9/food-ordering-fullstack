import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/mapper.dart';
import 'package:http/http.dart' as http;
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthApi implements IAuthApi {
  final http.Client _client;
  String baseUrl;
  AuthApi(this.baseUrl, this._client);
  @override
  Future<Result<String>> signIn(Credential credential) async {
    final endpoint = '$baseUrl/auth/signin';
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    final endpoint = '$baseUrl/auth/signup';
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(
      String endpoint, Credential credential) async {
    final response = await _client.post(Uri.parse(endpoint),
        body: jsonEncode(Mapper.toJson(credential)),
        headers: {"Content-type": "application/json"});
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      return Result.error(_transformErrors(map));
    }
    final json = jsonDecode(response.body);
    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message'] ?? 'Malformed json');
  }

  @override
  Future<Result<bool>> signOut(Token? token) async {
    final url = '$baseUrl/auth/signout';
    final headers = {
      "Content-type": "application/json",
      "Authorization": token!.value!,
    };
    final response = await _client.post(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) return Result.value(false);
    return Result.value(true);
  }

  _transformErrors(Map map) {
    final contents = map['error'] ?? map['errors'];
    if (contents is String) return contents;
    return contents
        .fold(
          '',
          (prev, ele) => prev + ele.values.first + '\n',
        )
        .trim();
  }
}
