// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/core/models/menu.dart' as model;
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class MenuItemHeader extends StatelessWidget {
  final model.MenuItem menuItem;
  final String menuSectionId;

  MenuItemHeader({required this.menuItem, required this.menuSectionId});

  @override
  Widget build(BuildContext context) {
    print('item id 1: ${menuItem.id}');
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.blurBackground],
      titlePadding: EdgeInsets.all(0),
      centerTitle: true,
      collapseMode: CollapseMode.parallax,
      background: Container(
        height: 250,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //image code
            Container(
              constraints: BoxConstraints.expand(),
              child: Hero(
                tag: menuItem.id! + menuSectionId,
                child: CachedImageNetwork(
                    image: menuItem.imageUrl!, imageHash: menuItem.imageHash!),
              ),
            ),
            //top grey shadow
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    end: const Alignment(0.0, 0.4),
                    begin: const Alignment(0.0, -1),
                    colors: <Color>[
                      Colors.black,
                      Colors.black12.withOpacity(0.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
