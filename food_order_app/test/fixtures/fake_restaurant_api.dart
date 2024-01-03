import 'package:restaurant/restaurant.dart';
import 'package:faker/faker.dart' as ff;
import 'package:collection/collection.dart';

class FakeRestaurantApi implements IRestaurantApi {
  List<Restaurant>? _restaurants;
  FakeRestaurantApi(int numberOfRestaurants) {
    final faker = ff.Faker();
    _restaurants = List.generate(
      numberOfRestaurants,
      (index) => Restaurant(
        id: index.toString(),
        name: faker.company.name(),
        displayImgUrl: faker.internet.httpUrl(),
        type: faker.food.cuisine(),
        location: Location(
            latitude: faker.randomGenerator.integer(5).toDouble(),
            longitue: faker.randomGenerator.integer(5).toDouble()),
        address: Address(
          street: faker.address.streetAddress(),
          city: faker.address.city(),
          parish: faker.address.country(),
        ),
      ),
    );
  }
  @override
  Future<Page?> findRestaurants(
      {required int page, required int pageSize, String? search}) async {
    final filter =
        search != null ? (Restaurant res) => res.name.contains(search) : null;
    return _paginatedRestaurants(page, pageSize, filter: filter);
  }

  @override
  Future<Page?> getAllRestaurant(
      {required int page, required int pageSize}) async {
    return _paginatedRestaurants(page, pageSize);
  }

  @override
  Future<Restaurant?> getRestaurant({required String id}) async {
    return _restaurants?.firstWhereOrNull(
      (restaurant) => restaurant.id == id,
    );
  }

  @override
  Future<List<Menu>> getRestaurantMenu({required String restaurantId}) {
    // TODO: implement getRestaurantMenu
    throw UnimplementedError();
  }

  @override
  Future<Page?> getRestaurantsByLocation(
      {required int page,
      required int pageSize,
      required Location? location}) async {
    final filter =
        location != null ? (Restaurant res) => res.location == location : null;
    return _paginatedRestaurants(page, pageSize, filter: filter);
  }

  Page _paginatedRestaurants(int page, int pageSize,
      {bool Function(Restaurant)? filter}) {
    final int offset = (page - 1) * pageSize;
    final restaurants =
        filter == null ? _restaurants : _restaurants?.where(filter).toList();

    final totalPages = ((restaurants?.length ?? 0) / pageSize).ceil();
    final result = restaurants?.skip(offset).take(pageSize).toList();

    return Page(
        currentPage: page, totalPages: totalPages, restaurants: result ?? []);
  }
}
