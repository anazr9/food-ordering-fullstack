import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_order_app/states_management/restaurant/restaurant_cubit.dart';
import 'package:food_order_app/ui/widgets/restaurant/menu_list.dart';

import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final RestaurantCubit restaurantCubit;

  const RestaurantPage(this.restaurant, this.restaurantCubit, {super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final List<Menu> menus = [];

  @override
  void initState() {
    widget.restaurantCubit.getRestaurantMenu(widget.restaurant.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 30.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            child: _menu(),
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: _header(),
            alignment: Alignment.topCenter,
          )
        ],
      ),
    );
  }

  _header() => FractionallySizedBox(
        heightFactor: 0.48,
        child: Stack(
          children: [
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.restaurant.displayImgUrl,
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        blurRadius: 0,
                        offset: const Offset(4, 4),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12.0,
                        ),
                        child: Text(
                          widget.restaurant.name,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          "${widget.restaurant.address.street}, ${widget.restaurant.address.city}, ${widget.restaurant.address.parish}",
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: 4.5,
                            itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: Colors.amber),
                            itemCount: 5,
                            itemSize: 30.0,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            '(4.5)',
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

  _menu() => FractionallySizedBox(
        heightFactor: 0.5,
        child: BlocBuilder<RestaurantCubit, RestaurantState>(
          bloc: widget.restaurantCubit,
          builder: (_, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ErrorState) {
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            }
            if (state is MenuLoaded) {
              menus.addAll(state.menu);
            }
            return _buildMenuList();
          },
        ),
      );

  _buildMenuList() => DefaultTabController(
        length: menus.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.black26,
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              tabs: menus
                  .map<Widget>(
                    (menu) => Tab(
                      text: menu.name,
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: menus
                    .map<Widget>(
                      (menu) => MenuList(menu.items),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      );
}
