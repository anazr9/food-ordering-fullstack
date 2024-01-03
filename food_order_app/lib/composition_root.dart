import 'package:auth/auth.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/cache/local_store.dart';
import 'package:food_order_app/cache/local_store_contract.dart';
import 'package:food_order_app/decorators/secure_client.dart';
import 'package:food_order_app/states_management/auth/auth_cubit.dart';
import 'package:food_order_app/states_management/helpers/header_cubit.dart';
import 'package:food_order_app/states_management/restaurant/restaurant_cubit.dart';
import 'package:food_order_app/ui/pages/auth/auth_page.dart';
import 'package:food_order_app/ui/pages/auth/auth_page_adapter.dart';
import 'package:food_order_app/ui/pages/home/home_page_adapter.dart';
import 'package:food_order_app/ui/pages/home/restaurant_list_page.dart';
import 'package:food_order_app/ui/pages/home/search_results_page.dart';
import 'package:food_order_app/ui/pages/restaurant/restaurant_page.dart';
import 'package:food_order_app/ui/pages/search_results/search_results_page_adapter.dart';
import 'package:restaurant/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class CompositionRoot {
  static SharedPreferences? _sharedPreferences;
  static ILocalStore? _localStore;
  static String? _baseUrl;
  static Client? _client;
  static RestaurantApi? _api;
  static AuthManager? manager;
  static IAuthApi? authApi;
  static SecureClient? _secureClient;
  static Future<void> configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _localStore = LocalStore(_sharedPreferences!);
    _client = Client();
    _baseUrl = '';
    _secureClient = SecureClient(HttpClientImpl(_client!), _localStore!);
    _api = RestaurantApi(_baseUrl!, _secureClient!);
    authApi = AuthApi(_baseUrl!, _client!);
    manager = AuthManager(authApi!);
  }

  static Widget composeAuthUi() {
    // AuthManager manager = AuthManager(api);
    AuthCubit authCubit = AuthCubit(_localStore!);
    ISignUpService signUpService = SignUpService(authApi!);
    IAuthPageAdaper adapter =
        AuthPageAdapter(onUserAuthenticated: composeHomeUi);
    return BlocProvider(
      create: (BuildContext context) => authCubit,
      child: AuthPage(manager!, signUpService, adapter),
    );
  }

  static Future<Widget> start() async {
    final token = await _localStore?.fetch();
    final authType = await _localStore?.fetchAuthType();
    final service = manager?.service(authType!);
    return token == null ? composeAuthUi() : composeHomeUi(service!);
  }

  static Widget composeHomeUi(IAuthService service) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 20);
    IHomePageAdapter adapter = HomePageAdapter(
        onSelection: _composeRestaurantPageWith,
        onSearch: _composeSearchResultsPageWith,
        onLogout: composeAuthUi);
    AuthCubit authCubit = AuthCubit(_localStore!);
    return MultiBlocProvider(providers: [
      BlocProvider<AuthCubit>(create: (BuildContext context) => authCubit),
      BlocProvider<RestaurantCubit>(
          create: (BuildContext context) => restaurantCubit),
      BlocProvider<HeaderCubit>(
          create: (BuildContext context) => HeaderCubit()),
    ], child: RestaurantListPage(adapter, service));
  }

  static Widget _composeSearchResultsPageWith(String query) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    ISearchResultsPageAdapter searchResultsPageAdapter =
        SearchResultsPageAdapter(onSelection: _composeRestaurantPageWith);
    return SearchResultsPage(restaurantCubit, query, searchResultsPageAdapter);
  }

  static Widget _composeRestaurantPageWith(Restaurant restaurant) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    return RestaurantPage(restaurant, restaurantCubit);
  }
}
