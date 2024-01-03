import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantListItem(this.restaurant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
              blurRadius: 0,
              offset: const Offset(5, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                restaurant.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                "${restaurant.address.street}, ${restaurant.address.city}, ${restaurant.address.parish}",
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8.0),
            RatingBarIndicator(
              rating: 4.5,
              itemBuilder: (context, index) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 50.0,
            ),
            Text('4.5', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8.0),
            Wrap(spacing: 8.0, runSpacing: 4.0, children: [
              _createChip('Vegetarian', context),
              _createChip('Vegan', context),
            ])
          ],
        ),
      ),
    );
  }

  Widget _createChip(String label, BuildContext context) {
    return Chip(
      backgroundColor: Colors.black87,
      label: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
