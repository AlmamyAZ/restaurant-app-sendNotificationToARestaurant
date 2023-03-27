// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class SpecialityItem extends StatelessWidget {
  final int nbPlaces;
  final String id;
  final String title;
  final String imgUrl;
  final String imageHash;

  SpecialityItem({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.imageHash,
    required this.nbPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        navigationService.navigateTo(Routes.restaurantsDisplayCategoryScreen,
            arguments: {'name': 'Cuisine $title', 'id': id});
      },
      child: Container(
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Container(
                child: CachedImageNetwork(image: imgUrl, imageHash: imageHash)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // StarsChip(
                //   icon: Icons.restaurant,
                //   color: Colors.white,
                //   text: '$nbPlaces lieu(x)',
                // ),
              ],
            ),
          ),
        ]),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
