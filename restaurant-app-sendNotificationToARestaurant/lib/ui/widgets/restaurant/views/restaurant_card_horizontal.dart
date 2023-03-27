// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/open_status_chip.dart';

class RestaurantCardHorizontal extends StatelessWidget {
  final String id;
  final String name;
  final String phoneNumber;
  final String adress;
  final String imageUrl;
  final List<Map<String, dynamic>> openHours;
  final List<Map<String, dynamic>> kitchenSpeciality;
  final double rating;
  final int ratingCount;
  final String imageHash;
  final bool? openStatus;
  final Function getDistance;


  const RestaurantCardHorizontal({
    Key? key,
    required this.id,
    required this.name,
    this.openStatus,
    required this.adress,
    required this.rating,
    required this.openHours,
    required this.ratingCount,
    required this.imageUrl,
    required this.kitchenSpeciality,
    required this.imageHash,
    required this.getDistance,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushWithPopRestartRestaurantId(
            id, name, imageUrl, imageHash, openHours, phoneNumber);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedImageNetwork(
                        image: imageUrl, imageHash: imageHash),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: OpenStatusChip(isOpen(openHours)),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 8,
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.headline6,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Text(
                              getDistance(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      flattenMapToString(kitchenSpeciality),
                      style: Theme.of(context).textTheme.subtitle1,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        horizontalSpaceSmall,
                        Text(
                          rating.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                        ),
                        horizontalSpaceSmall,
                        Text('($ratingCount notes)'),
                      ],
                    ),
                    Divider()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
