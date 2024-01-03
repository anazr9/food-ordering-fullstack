import 'package:flutter_test/flutter_test.dart';
import 'package:food_order_app/states_management/restaurant/restaurant_cubit.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:bloc_test/bloc_test.dart';
import '../fixtures/fake_restaurant_api.dart';

void main() {
  RestaurantCubit? sut;
  FakeRestaurantApi api;

  setUp(() {
    api = FakeRestaurantApi(19);
    sut = RestaurantCubit(api, defaultPageSize: 10);
  });

  tearDown(() {
    sut?.close();
  });
  group('getAllRestaurants', () {
    blocTest(
      'returns first page with correct number of restaurants',
      build: () => sut!,
      act: (cubit) => sut?.getAllRestaurants(page: 1),
      expect: () => [
        const matcher.TypeMatcher<Loading>(),
        const matcher.TypeMatcher<PageLoaded>(),
      ],
      verify: (cubit) {
        final state = cubit.state as PageLoaded;
        expect(state.nextPage, equals(2));
        expect(state.restaurants.length, 10);
      },
    );
    blocTest(
      'returns last page with correct number of restaurants',
      build: () => sut!,
      act: (cubit) => sut?.getAllRestaurants(page: 2),
      expect: () => [
        const matcher.TypeMatcher<Loading>(),
        const matcher.TypeMatcher<PageLoaded>(),
      ],
      verify: (cubit) {
        final state = cubit.state as PageLoaded;
        expect(state.nextPage, null);
        expect(state.restaurants.length, 9);
      },
    );
  });
  group('getRestaurant', () {
    blocTest(
      'returns restaurants when found',
      build: () => sut!,
      act: (cubit) => sut?.getRestaurant('1'),
      expect: () => [
        const matcher.TypeMatcher<Loading>(),
        const matcher.TypeMatcher<RestaurantLoaded>(),
      ],
      verify: (cubit) {
        final state = cubit.state as RestaurantLoaded;
        expect(state.restaurant, isNotNull);
      },
    );
    blocTest(
      'returns error when restaurant is not found',
      build: () => sut!,
      act: (cubit) => sut?.getRestaurant('-1'),
      expect: () => [
        const matcher.TypeMatcher<Loading>(),
        const matcher.TypeMatcher<ErrorState>(),
      ],
      verify: (cubit) {
        final state = cubit.state as ErrorState;
        expect(state.message, isNotNull);
      },
    );
  });
}
