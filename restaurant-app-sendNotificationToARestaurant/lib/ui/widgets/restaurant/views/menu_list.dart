// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/menu.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class MenuList extends StatelessWidget {
  final List<MenuSection> menuSections;
  final String restaurantId;
  MenuList({required this.menuSections, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return SectionTile(
                menuSection: menuSections[index], restaurantId: restaurantId);
          },
          childCount: menuSections.length,
        ),
      ),
    );
  }
}

class SectionTile extends StatefulWidget {
  final MenuSection menuSection;
  final String restaurantId;

  const SectionTile({
    required this.menuSection,
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  @override
  _SectionTileState createState() => _SectionTileState();
}

class _SectionTileState extends State<SectionTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          contentPadding: EdgeInsets.all(0),
          leading: _isExpanded
              ? Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.arrow_right,
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
          title: Text(
            widget.menuSection.name!,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (_isExpanded)
          Container(
            child: Column(
              children: widget.menuSection.menuItems!.map((el) {
                return InkWell(
                  onTap: () {
                    navigationService
                        .navigateTo(Routes.menuItemDetailsScreen, arguments: {
                      'menuItem': el,
                      'restaurantId': widget.restaurantId,
                      'menuSectionId': widget.menuSection.id,
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        el.alias!,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            el.description!,
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          verticalSpaceSmall,
                          Text(
                            formatCurrency(el.price!),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      trailing: Container(
                        width: screenWidth(context) / 4,
                        child: Hero(
                          tag: el.id! + widget.menuSection.id!,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              child: CachedImageNetwork(
                                  image: el.imageUrl200!,
                                  imageHash: el.imageHash!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
      ],
    );
  }
}
