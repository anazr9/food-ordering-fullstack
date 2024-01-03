import 'package:equatable/equatable.dart';

class Restaurant {
  final String id;
  final String name;
  final String displayImgUrl;
  final String type;
  final Location location;
  final Address address;

  Restaurant(
      {required this.id,
      required this.name,
      required this.displayImgUrl,
      required this.type,
      required this.location,
      required this.address});
}

class Location extends Equatable {
  final double latitude;
  final double longitue;
  const Location({
    required this.latitude,
    required this.longitue,
  });

  @override
  List<Object?> get props => [longitue, latitude];
}

class Address extends Equatable {
  final String street;
  final String city;
  final String parish;
  final String? zone;

  const Address(
      {required this.street,
      required this.city,
      required this.parish,
      this.zone});

  @override
  List<Object?> get props => [street, city, parish, zone];
}
