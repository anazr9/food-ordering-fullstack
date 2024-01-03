import 'package:flutter/material.dart';
import 'package:food_order_app/ui/widgets/custom_flat_button.dart';
import 'package:food_order_app/utils/utils.dart';

import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuList extends StatefulWidget {
  final List<MenuItem> menuItems;

  const MenuList(this.menuItems, {super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            onTap: () {
              showAddToBasketOption(context, widget.menuItems[index]);
            },
            child: ListTile(
              isThreeLine: false,
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/id/292/300',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.menuItems[index].name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    doubleToCurrency(widget.menuItems[index].unitPrice),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
              subtitle: Text(
                widget.menuItems[index].desc,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _, index) => const Divider(),
      itemCount: widget.menuItems.length,
    );
  }

  showAddToBasketOption(BuildContext context, MenuItem menuItem) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (context) => Container(
        height: 160,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16, bottom: 20.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    menuItem.name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  doubleToCurrency(menuItem.unitPrice),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.black26,
                    ),
                  ),
                  Text(
                    '1',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              CustomFlatButton(
                  onPressed: () {},
                  text: 'Add to Basket',
                  size: const Size(double.infinity, 45),
                  color: Theme.of(context).colorScheme.secondary)
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
