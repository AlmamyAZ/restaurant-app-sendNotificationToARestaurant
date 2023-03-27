// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/location_chip.dart';
import '../../uielements/open_status_chip.dart';
import '../../uielements/stars_chip.dart';

class RestaurantCardLarge extends StatelessWidget {
  final String id;
  final String name;
  final String adress;
  final String imageUrl;
  final List<Map<String, dynamic>> kitchenSpeciality;
  final double rating;
  final String imageHash;
  final bool? openStatus;
  final List<Map<String, dynamic>> openHours;

  const RestaurantCardLarge({
    Key? key,
    required this.id,
    required this.name,
    this.openStatus,
    required this.adress,
    required this.rating,
    required this.imageUrl,
    required this.kitchenSpeciality,
    required this.imageHash,
    required this.openHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationService.navigateTo(Routes.bottomTabsRestaurant, arguments: {
          'id': id,
          'name': name,
          'imageUrl': imageUrl,
          'imageHash': imageHash,
        });
      },
      child: Container(
          width: 280,
          padding: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 176,
                      width: double.infinity,
                      child: CachedImageNetwork(
                          image: imageUrl, imageHash: imageHash),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 176,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(5))),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OpenStatusChip(isOpen(openHours)),
                    ],
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          width: 270,
                          child: Text(
                            flattenMapToString(kitchenSpeciality),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StarsChip(
                                icon: Icons.star,
                                color: Colors.yellow[800]!,
                                text: rating.toString(),
                              ),
                              LocationChip(
                                icon: Icons.location_on,
                                color: Colors.white,
                                fontSize: 13,
                                text: adress,
                              )
                            ],
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
