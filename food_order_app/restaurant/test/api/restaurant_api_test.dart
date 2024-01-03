import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant/src/api/restaurant_api.dart';
import 'package:restaurant/src/domain/restaurant.dart';

class MockClient extends Mock implements IHttpClient {}

class FakeUri extends Fake implements Uri {}

void main() {
  RestaurantApi? sut;
  MockClient? client;
  setUp(() {
    client = MockClient();
    registerFallbackValue(FakeUri());
    sut = RestaurantApi('baseUrl', client!);
  });
  group('getAllRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(() => client?.get(
            any(),
          )).thenAnswer((_) async => HttpResult(
          jsonEncode({
            "metadata": {"page": 1, "totalPages": 2},
            "restaurants": []
          }),
          Status.sucess));
      //act
      final page = await sut?.getAllRestaurant(page: 1, pageSize: 2);
      //assert
      expect(page?.restaurants, []);
    });
    test('returns null when status code is not 200', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async => HttpResult(jsonEncode({}), Status.failure));
      //act
      final page = await sut?.getAllRestaurant(page: 1, pageSize: 2);
      //assert
      expect(page, isNull);
    });
    test('returns list of restaurants when success', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async =>
              HttpResult(jsonEncode(_restaurantJson()), Status.sucess));
      //act
      final page = await sut?.getAllRestaurant(page: 1, pageSize: 2);
      //assert
      expect(page?.restaurants.length, 2);
    });
  });
  group('getRestaurant', () {
    test('returns null when restaurant is not found', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async => HttpResult(
              jsonEncode({"error": "restaurant not found"}), Status.failure));
      //act
      final result = await sut?.getRestaurant(id: "12334");
      //assert
      expect(result, null);
    });
    test('returns restaurant when success', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async => HttpResult(
              jsonEncode(_restaurantJson()["restaurants"][0]), Status.sucess));
      //act
      final result = await sut?.getRestaurant(id: "12345");
      //assert
      expect(result, isNotNull);
      expect(result?.id, "12345");
    });
  });
  group('getRestaurantByLocation', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(() => client?.get(
            any(),
          )).thenAnswer((_) async => HttpResult(
          jsonEncode({
            "metadata": {"page": 1, "totalPages": 2},
            "restaurants": []
          }),
          Status.sucess));
      //act
      final page = await sut?.getRestaurantsByLocation(
        page: 1,
        pageSize: 2,
        location: const Location(
          latitude: 1233,
          longitue: 12.45,
        ),
      );
      //assert
      expect(page?.restaurants, []);
    });

    test('returns list of restaurants when success', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async =>
              HttpResult(jsonEncode(_restaurantJson()), Status.sucess));
      //act
      final page = await sut?.getRestaurantsByLocation(
        page: 1,
        pageSize: 2,
        location: const Location(
          latitude: 1233,
          longitue: 12.45,
        ),
      );
      //assert
      expect(page?.restaurants, isNotEmpty);
      expect(page?.restaurants.length, 2);
    });
  });
  group('findRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(() => client?.get(
            any(),
          )).thenAnswer((_) async => HttpResult(
          jsonEncode({
            "metadata": {"page": 1, "totalPages": 2},
            "restaurants": []
          }),
          Status.sucess));
      //act
      final page = await sut?.findRestaurants(
        page: 1,
        pageSize: 2,
        search: "blagg",
      );
      //assert
      expect(page?.restaurants, []);
    });

    test('returns list of restaurants when success', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async =>
              HttpResult(jsonEncode(_restaurantJson()), Status.sucess));
      //act
      final page = await sut?.findRestaurants(
        page: 1,
        pageSize: 2,
        search: "blaaas",
      );
      //assert
      expect(page?.restaurants, isNotEmpty);
      expect(page?.restaurants.length, 2);
    });
  });
  group('getRestaurantMenu', () {
    test('returns an empty list when no menu are found', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer(
              (_) async => HttpResult(jsonEncode({"menu": []}), Status.sucess));
      //act
      final results = await sut?.getRestaurantMenu(
        restaurantId: '12345',
      );
      //assert
      expect(results, []);
    });

    test('returns restaurant menu when success', () async {
      //arrange
      when(() => client?.get(
                any(),
              ))
          .thenAnswer((_) async => HttpResult(
              jsonEncode({"menu": _restaurantMenuJson()}), Status.sucess));
      //act
      final results = await sut?.getRestaurantMenu(
        restaurantId: '12345',
      );
      //assert
      expect(results, isNotEmpty);
      expect(results?.length, 1);
      expect(results?.first.id, "12345");
    });
  });
}

_restaurantJson() => {
      "metadata": {"page": 1, "totalPages": 2},
      "restaurants": [
        {
          "id": "12345",
          "name": "Restaurant Name",
          "type": "fast food",
          "image_url": "restaurant.jpg",
          "location": {"longitude": 345.33, "latitude": 345.45},
          "address": {
            "street": "Road 1",
            "city": "City",
            "parish": "Parish",
            "zone": "zone",
          }
        },
        {
          "id": "12666",
          "name": "Restaurant Name",
          "type": "fast food",
          "image_url": "restaurant.jpg",
          "location": {"longitude": 345.44, "latitude": 345.44},
          "address": {
            "street": "Road 1",
            "city": "City",
            "parish": "Parish",
            "zone": "zone",
          }
        }
      ]
    };
_restaurantMenuJson() => [
      {
        "id": "12345",
        "name": "Lunch",
        "description": "a fun menu",
        "image_url": "menu.jpg",
        "items": [
          {
            "name": "nuff food",
            "description": "awesome!!",
            "image_urls": ["url1", "url2"],
            "unit_price": 12.99,
          },
          {
            "name": "nuff food",
            "description": "awesome!!",
            "image_urls": ["url1", "url2"],
            "unit_price": 12.99,
          },
        ]
      }
    ];
