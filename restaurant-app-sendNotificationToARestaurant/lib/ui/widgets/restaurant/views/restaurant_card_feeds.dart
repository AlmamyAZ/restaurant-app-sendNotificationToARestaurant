// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/location_chip.dart';
import '../../uielements/open_status_chip.dart';
import '../../uielements/stars_chip.dart';

class RestaurantCardFeeds extends StatelessWidget {
  final String id;
  final bool grid;
  final String name;
  final String phoneNumber;
  final String adress;
  final String distance;
  final String imageUrl;
  final List<Map<String, dynamic>> kitchenSpeciality;
  final double rating;
  final String imageHash;
  final bool? openStatus;
  final List<Map<String, dynamic>> openHours;

  const RestaurantCardFeeds({
    Key? key,
    required this.id,
     this.grid = false,
    required this.name,
    required this.distance,
     this.openStatus,
    required this.openHours,
    required this.adress,
    required this.rating,
    required this.imageUrl,
    required this.kitchenSpeciality,
    required this.imageHash,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(key),
      onTap: () {
        pushWithPopRestartRestaurantId(
            id, name, imageUrl, imageHash, openHours, phoneNumber);
      },
      child: Container(
          width: double.infinity,
          // padding: grid ? null : EdgeInsets.only(right: 15),
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: CachedImageNetwork(
                          image: imageUrl, imageHash: imageHash),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OpenStatusChip(isOpen(openHours)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$distance',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              verticalSpaceTiny,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StarsChip(
                    icon: Icons.star,
                    color: Colors.yellow[800]!,
                    text: rating.toString(),
                  ),
                  LocationChip(
                    icon: Icons.location_on,
                    color: Colors.black87,
                    fontSize: 12,
                    text: adress,
                  )
                ],
              ),
              verticalSpaceTiny,
              Text(
                flattenMapToString(kitchenSpeciality),
                style: Theme.of(context).textTheme.subtitle1,
                 maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ],
          ),),
    );
  }
}
