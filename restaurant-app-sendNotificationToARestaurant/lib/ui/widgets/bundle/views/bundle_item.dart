// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class BundleItem extends StatelessWidget {
  final String name;
  final String id;
  final String image;
  final String imageHash;
  final bool hasCategories;
  final List<String> categories;
  BundleItem(
      {required this.id,
      required this.name,
      required this.imageHash,
      required this.image,
      required this.hasCategories,
      required this.categories});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (hasCategories) {
          navigationService
              .navigateTo(Routes.restaurantsSpecialitiesScreen, arguments: {
            "name": name,
            "categories": categories,
          });
        } else {
          navigationService.navigateTo(
            Routes.restaurantsDisplayBundleScreen,
            arguments: {
              'name': name,
              'categories': categories,
              'id': id,
            },
          );
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: CachedImageNetwork(image: image, imageHash: imageHash),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
