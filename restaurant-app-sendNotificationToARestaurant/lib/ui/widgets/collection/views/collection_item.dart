// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/collection.dart';
import '../../uielements/stars_chip.dart';

class CollectionItem extends StatelessWidget {
  final Collection collection;

  CollectionItem({ required this.collection});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        navigationService.navigateTo(
          Routes.restaurantsDisplayCollectionScreen,
          arguments: collection,
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          Positioned(
            right: 0,
            child: collection.isDefault!
                ? Icon(
                    Icons.collections_bookmark,
                    size: 90,
                    color: Colors.black.withOpacity(0.1),
                  )
                : Icon(
                    Icons.bookmark_border,
                    size: 90,
                    color: Colors.black.withOpacity(0.1),
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 30,
                child: FittedBox(
                  // fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft,
                  child: Text(
                    collection.title!,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              StarsChip(
                icon: Icons.restaurant,
                color: Colors.blueGrey[900]!,
                text: '${collection.nbPlaces} lieu(x)',
              ),
            ],
          ),
        ]),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(int.parse('0x${collection.color}')).withOpacity(0.7),
                Color(int.parse('0x${collection.color}'))
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
