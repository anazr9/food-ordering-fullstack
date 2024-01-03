import 'package:restaurant/src/domain/menu.dart';
import 'package:restaurant/src/domain/restaurant.dart';

class Mapper {
  static fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        displayImgUrl: json["displayImgUrl"] ?? '',
        type: json["type"],
        location: Location(
            latitude: json['location']['latitude'],
            longitue: json['location']['longitude']),
        address: Address(
          street: json['address']['street'],
          city: json['address']['city'],
          parish: json['address']['parish'],
          zone: json['address']['zone'] ?? '',
        ),
      );
  static menuFromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"],
        desc: json['description'],
        displayImgUr: json['image_url'] ?? '',
        items: json['items'] != null
            ? json['items']
                .map<MenuItem>((item) => MenuItem(
                    name: item['name'],
                    desc: item['description'],
                    imgUrl: item['imageUrls'].cast<String>(),
                    unitPrice: item['unitPrice'].toDouble()))
                .toList()
            : null,
      );
}
