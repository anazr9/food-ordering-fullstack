part of 'restaurant_cubit.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class Initial extends RestaurantState {
  const Initial();
  @override
  List<Object> get props => [];
}

class Loading extends RestaurantState {
  const Loading();
  @override
  List<Object> get props => [];
}

class PageLoaded extends RestaurantState {
  final Page _page;
  const PageLoaded(this._page);
  List<Restaurant> get restaurants => _page.restaurants;
  int? get nextPage => _page.isLast ? null : _page.currentPage + 1;
  @override
  List<Object> get props => [_page];
}

class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;
  const RestaurantLoaded(this.restaurant);

  @override
  List<Object> get props => [restaurant];
}

class MenuLoaded extends RestaurantState {
  final List<Menu> menu;
  const MenuLoaded(this.menu);

  @override
  List<Object> get props => [menu];
}

class ErrorState extends RestaurantState {
  final String message;
  const ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
