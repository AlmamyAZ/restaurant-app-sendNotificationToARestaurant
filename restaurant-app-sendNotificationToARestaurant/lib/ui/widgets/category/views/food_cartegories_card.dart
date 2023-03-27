// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class FoodCategoriesCard extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final String imageHash;

  const FoodCategoriesCard({
    Key? key,
    required this.name,
    required this.imgUrl,
    required this.imageHash,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationService.navigateTo(Routes.restaurantsDisplayCategoryScreen,
            arguments: {'name': 'Cuisine $name', 'id': id});
      },
      child: Container(
          width: 110,
          height: 100,
          padding: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedImageNetwork(
                          image: imgUrl, imageHash: imageHash),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(5))),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
