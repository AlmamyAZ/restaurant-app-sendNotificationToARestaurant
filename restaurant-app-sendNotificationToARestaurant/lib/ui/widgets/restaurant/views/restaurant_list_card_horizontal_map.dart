// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/map/restaurants_map_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';
import '../../uielements/open_status_chip.dart';

class RestaurantListCardHorizontalMap
    extends ViewModelWidget<RestaurantsMapViewModel> {
  @override
  Widget build(BuildContext context, RestaurantsMapViewModel model) {
    return Container(
      height: 120,
      child: ScrollablePositionedList.builder(
        scrollDirection: Axis.horizontal,
        itemScrollController: model.scrollController,
        itemPositionsListener: model.itemPositionsListener,
        itemCount: model.restaurants.length,
        itemBuilder: (BuildContext context, int index) {
          return RestaurantCardHorizontalMap(
            restaurant: model.restaurants[index],
            getDistance: model.getDistance,
          );
        },
      ),
    );
  }
}

class RestaurantCardHorizontalMap extends StatelessWidget {
  final Restaurant restaurant;
  final Function getDistance;
  const RestaurantCardHorizontalMap({
    required this.restaurant,
    required this.getDistance,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushWithPopRestartRestaurantId(
            restaurant.id!,
            restaurant.name!,
            restaurant.imageUrl!,
            restaurant.imageHash!,
            restaurant.openHours!,
            restaurant.phoneNumber!);
      },
      child: Card(
        elevation: 5,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
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
                      padding: EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedImageNetwork(
                          image: restaurant.imageUrl!,
                          imageHash: restaurant.imageHash!,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 3,
                        right: 3,
                        child: OpenStatusChip(isOpen(restaurant.openHours!))),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                restaurant.name!,
                                style: Theme.of(context).textTheme.headline6,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              getDistance(restaurant),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        flattenMapToString(restaurant.kitchenSpeciality!),
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: restaurant.rating!.toDouble(),
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
                            restaurant.rating!.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                          ),
                          horizontalSpaceSmall,
                          Text('(${restaurant.ratingCount!} notes)'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
