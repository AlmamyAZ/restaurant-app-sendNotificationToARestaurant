// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/stars_chip.dart';

class FoodItem extends StatelessWidget {
  final String id;
  final String foodGenericId;
  final String name;
  final int likerCount;
  final String speciality;
  final String description;
  final String ingredients;
  final DateTime createdAt;
  final String imageUrl;
  final String imageHash;

  const FoodItem({
    Key? key,
    required this.id,
    required this.foodGenericId,
    required this.name,
    required this.likerCount,
    required this.speciality,
    required this.description,
    required this.ingredients,
    required this.createdAt,
    required this.imageUrl,
    required this.imageHash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationService.navigateTo(Routes.foodDetailsScreen, arguments: {
          'id': id,
          'imageUrl': imageUrl,
          'imageHash': imageHash,
          'name': name
        });
      },
      child: Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: id,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        height: 115,
                        width: double.infinity,
                        child: CachedImageNetwork(
                            image: imageUrl, imageHash: imageHash),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StarsChip(
                          icon: Icons.favorite,
                          color: Colors.red,
                          text: '$likerCount kiff(s)',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
