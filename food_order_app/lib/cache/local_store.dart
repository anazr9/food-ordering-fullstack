import 'package:auth/auth.dart';
import 'package:food_order_app/cache/local_store_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedToken = 'CACHED_TOKEN';
const cachedAuth = 'CACHED_AUTH';

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPreferences;
  LocalStore(this.sharedPreferences);
  @override
  delete(Token? token) {
    sharedPreferences.remove(cachedToken);
  }

  @override
  Future<Token?> fetch() async {
    final tokenStr = sharedPreferences.getString(cachedToken);
    if (tokenStr != null) return Future.value(Token(tokenStr));
    return null;
  }

  @override
  Future save(Token token) {
    return sharedPreferences.setString(cachedToken, token.value!);
  }

  @override
  Future<AuthType?> fetchAuthType() async {
    final authType = sharedPreferences.getString(cachedAuth);
    if (authType != null) {
      return Future.value(AuthType.values
          .firstWhere((element) => element.toString() == authType));
    }
    return null;
  }

  @override
  Future saveAuthType(AuthType type) {
    return sharedPreferences.setString(cachedAuth, type.toString());
  }
}
