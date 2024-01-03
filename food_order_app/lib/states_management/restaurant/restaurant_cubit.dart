import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/restaurant.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final IRestaurantApi _api;
  final int _pageSize;
  RestaurantCubit(this._api, {int defaultPageSize = 30})
      : _pageSize = defaultPageSize,
        super(const Initial());
  getAllRestaurants({required int page}) async {
    _startLoading();
    final pageResult = await _api.getAllRestaurant(
      page: page,
      pageSize: _pageSize,
    );
    pageResult == null || pageResult.restaurants.isEmpty
        ? _showError('no restaurant found')
        : _setPageData(pageResult);
  }

  getRestaurantsByLocation(int page, Location location) async {
    _startLoading();
    final pageResult = await _api.getRestaurantsByLocation(
        page: page, pageSize: _pageSize, location: location);
    pageResult == null || pageResult.restaurants.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  search(int page, String query) async {
    _startLoading();
    final searchResults = await _api.findRestaurants(
        page: page, pageSize: _pageSize, search: query);
    searchResults == null || searchResults.restaurants.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(searchResults);
  }

  getRestaurant(String id) async {
    _startLoading();
    final restaurant = await _api.getRestaurant(id: id);
    restaurant != null
        ? emit(RestaurantLoaded(restaurant))
        : emit(const ErrorState("restaurant not found"));
  }

  getRestaurantMenu(String restaurantId) async {
    _startLoading();
    final menu = await _api.getRestaurantMenu(restaurantId: restaurantId);
    menu != null
        ? emit(MenuLoaded(menu))
        : emit(const ErrorState("no menu found for this restaurant"));
  }

  _startLoading() {
    emit(const Loading());
  }

  _setPageData(Page result) {
    emit(PageLoaded(result));
  }

  _showError(String error) {
    emit(ErrorState(error));
  }
}
