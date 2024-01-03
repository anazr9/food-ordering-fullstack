class Menu {
  final String id;
  final String name;
  final String desc;
  final String? displayImgUr;
  final List<MenuItem> items;

  Menu(
      {required this.id,
      required this.name,
      required this.desc,
      this.displayImgUr,
      required this.items});
}

class MenuItem {
  final String name;
  final String desc;
  final List<String>? imgUrl;
  final double unitPrice;

  MenuItem(
      {required this.name,
      required this.desc,
      this.imgUrl,
      required this.unitPrice});
}
