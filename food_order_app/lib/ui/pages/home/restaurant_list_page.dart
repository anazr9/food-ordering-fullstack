import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/models/header.dart';
import 'package:food_order_app/states_management/helpers/header_cubit.dart';
import 'package:food_order_app/ui/pages/home/home_page_adapter.dart';
import 'package:food_order_app/ui/widgets/custom_text_field.dart';
import 'package:food_order_app/ui/widgets/restaurant_list_item.dart';
import 'package:food_order_app/utils/utils.dart';
import 'package:restaurant/restaurant.dart';

import 'package:food_order_app/states_management/auth/auth_cubit.dart';
import 'package:food_order_app/states_management/auth/auth_state.dart'
    as auth_state;
import 'package:food_order_app/states_management/restaurant/restaurant_cubit.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantListPage extends StatefulWidget {
  final IHomePageAdapter adapter;
  final IAuthService service;

  const RestaurantListPage(this.adapter, this.service, {super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  PageLoaded? currentState;
  List<Restaurant> restaurants = [];
  double currentIndex = 0;
  double previousIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurants(page: 1);
    super.initState();
    _onScrollListener();
  }

  void _onScrollListener() {
    _scrollController.addListener(() {
      currentIndex = (_scrollController.offset.round() / 240).floorToDouble();
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          currentState?.nextPage != null) {
        BlocProvider.of<RestaurantCubit>(context)
            .getAllRestaurants(page: currentState!.nextPage!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.power_settings_new_rounded,
            size: 36.0,
          ),
          onPressed: () {
            _logout();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_basket_outlined,
                size: 38.8,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              child: _header(),
              alignment: Alignment.topCenter,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: BlocConsumer<RestaurantCubit, RestaurantState>(
                    builder: (_, state) {
                  if (state is PageLoaded) {
                    currentState = state;
                    restaurants.addAll(state.restaurants);
                    _updateHeader();
                  }

                  if (currentState == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return _buildListOfRestaurants();
                }, listener: (context, state) {
                  if (state is ErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: BlocListener<AuthCubit, auth_state.AuthState>(
                  child: Container(),
                  listener: (context, state) {
                    if (state is auth_state.LoadingState) {
                      _showLoader();
                    }
                    if (state is auth_state.SignOutSuccessState) {
                      widget.adapter.onUserLogout(context);
                    }
                    if (state is auth_state.ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                          ),
                        ),
                      );
                      _hideLoader();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _header() => Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        height: 350.0,
        child: Stack(
          children: [
            BlocBuilder<HeaderCubit, Header>(
              builder: (_, state) => _buildDynamicHeaderInfo(state),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 70.0),
                child: CustomTextField(
                    hint: 'find restaurants',
                    fontSize: 14.0,
                    height: 48.0,
                    fontWeight: FontWeight.normal,
                    onChanged: (val) {},
                    inputAction: TextInputAction.search,
                    onSubmitted: (query) {
                      if (query.isEmpty) return;
                      widget.adapter.onSearchQuery(context, query);
                    }),
              ),
            )
          ],
        ),
      );

  _buildDynamicHeaderInfo(Header header) => Stack(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: header.imageUrl!,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  header.title!,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          )
        ],
      );

  _buildListOfRestaurants() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        if (currentIndex != previousIndex) {
          _updateHeader();
          previousIndex = currentIndex;
        }
        return true;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 40.0),
        itemBuilder: (context, index) {
          return index >= restaurants.length
              ? bottomLoader()
              : GestureDetector(
                  onTap: () => widget.adapter
                      .onRestaurantSelected(context, restaurants[index]),
                  child: RestaurantListItem(restaurants[index]),
                );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: currentState?.nextPage == null
            ? restaurants.length
            : restaurants.length + 1,
        controller: _scrollController,
      ),
    );
  }

  _updateHeader() {
    var restaurant = restaurants[currentIndex.toInt()];
    BlocProvider.of<HeaderCubit>(context).update(
      restaurant.type,
      restaurant.displayImgUrl,
    );
  }

  _logout() {
    BlocProvider.of<AuthCubit>(context).signout(widget.service);
  }

  _showLoader() {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
