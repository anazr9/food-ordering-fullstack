import 'package:common/common.dart';
import 'package:food_order_app/cache/local_store_contract.dart';

class SecureClient implements IHttpClient {
  final IHttpClient client;
  final ILocalStore store;
  SecureClient(this.client, this.store);

  @override
  Future<HttpResult> get(url, {Map<String, String>? headers}) async {
    final token = await store.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token!.value!;
    return await client.get(url, headers: modifiedHeader);
  }

  @override
  Future<HttpResult> post(url, String body,
      {Map<String, String>? headers}) async {
    final token = await store.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token!.value!;
    return await client.post(url, body, headers: modifiedHeader);
  }
}
