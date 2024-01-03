import 'dart:convert';

import 'package:common/common.dart';
import 'package:restaurant/src/api/api_contract.dart';
import 'package:restaurant/src/api/mapper.dart';
import 'package:restaurant/src/api/page.dart';
import 'package:restaurant/src/domain/menu.dart';
import 'package:restaurant/src/domain/restaurant.dart';

class RestaurantApi implements IRestaurantApi {
  final IHttpClient httpClient;
  final String baseUrl;

  RestaurantApi(
    this.baseUrl,
    this.httpClient,
  );

  @override
  Future<Page?> findRestaurants(
      {required int page,
      required int pageSize,
      required String? search}) async {
    final endpoint =
        '$baseUrl/restaurants/search?page=$page&limit=$pageSize&query=$search';
    final result = await httpClient.get(Uri.parse(endpoint));
    return _parseRestaurantsJson(result);
  }

  @override
  Future<Page?> getAllRestaurant({
    required int page,
    required int pageSize,
  }) async {
    final endpoint = '$baseUrl/restaurants?page=$page&limit=$pageSize';
    final result = await httpClient.get(Uri.parse(endpoint));
    return _parseRestaurantsJson(result);
  }

  @override
  Future<Restaurant?> getRestaurant({required String id}) async {
    final endPoint = '$baseUrl/restaurants/restaurant/$id';
    final result = await httpClient.get(Uri.parse(endPoint));
    if (result.status == Status.failure) return null;
    final json = jsonDecode(result.data);
    return Mapper.fromJson(json);
  }

  @override
  Future<Page?> getRestaurantsByLocation(
      {required int page,
      required int pageSize,
      required Location? location}) async {
    final endpoint =
        '$baseUrl/restaurants/location?page=$page&limit=$pageSize&longitude=${location?.longitue}&latitude=${location?.latitude}';
    final result = await httpClient.get(Uri.parse(endpoint));
    return _parseRestaurantsJson(result);
  }

  @override
  Future<List<Menu>> getRestaurantMenu({required String restaurantId}) async {
    final endpoint = '$baseUrl/restaurants/restaurant/menu/$restaurantId';
    final result = await httpClient.get(Uri.parse(endpoint));
    return _parseRestaurantsMenu(result);
  }

  Page? _parseRestaurantsJson(HttpResult result) {
    if (result.status == Status.failure) return null;
    final json = jsonDecode(result.data);
    final List<Restaurant> restaurants =
        json['restaurants'] != null ? _restaurantsFromJson(json) : [];
    return Page(
      totalPages: json['metadata']['limit'],
      currentPage: json['metadata']['page'],
      restaurants: restaurants,
    );
  }

  List<Menu> _parseRestaurantsMenu(HttpResult result) {
    if (result.status == Status.failure) return [];
    final json = jsonDecode(result.data);
    if (json['menu'] == null) return [];
    final List menus = json['menu'];
    return menus.map<Menu>((e) => Mapper.menuFromJson(e)).toList();
  }

  List<Restaurant> _restaurantsFromJson(Map<String, dynamic> json) {
    final List restaurants = json['restaurants'];
    return restaurants.map<Restaurant>((ele) => Mapper.fromJson(ele)).toList();
  }
}
