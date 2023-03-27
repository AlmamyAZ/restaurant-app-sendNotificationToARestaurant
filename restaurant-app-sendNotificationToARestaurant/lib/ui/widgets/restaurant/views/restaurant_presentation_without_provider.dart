// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class RestaurantPresentationWithoutProvider extends StatelessWidget {
  final BottomTabsRestaurantViewModel model;

  RestaurantPresentationWithoutProvider({required this.model});

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = model.restaurant!;
    return model.busy(model.restaurant)
        ? RestaurantPresentationSkeleton()
        : Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Text(
                            restaurant.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontSize: 29),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        model.getDistance(restaurant.position!),
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
                  restaurant.adress!,
                  style: TextStyle(
                    // color: textColor == null ? color : textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  model.getJoinKitchenSpeciality(restaurant.kitchenSpeciality!),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 5),
                RestaurantReviewPreview(
                  ratingCount: restaurant.ratingCount!,
                  rating: restaurant.rating!,
                ),
                verticalSpaceSmall,
                PriceRange(priceRate: restaurant.priceRate!),
                verticalSpaceSmall,
                RestaurantOpenHours(
                    status: restaurant.openStatus,
                    weekHours: restaurant.openHours!),
                Divider(),
              ],
            ),
          );
  }
}

class PriceRange extends StatelessWidget {
  final int priceRate;

  PriceRange({
    required this.priceRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Prix du menu',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 16),
        ),
        horizontalSpaceMedium,
        RatingBarIndicator(
          rating: priceRate.toDouble(),
          itemBuilder: (context, index) => Icon(
            Icons.monetization_on,
            color: Colors.green[500],
          ),
          itemCount: 3,
          itemSize: 20.0,
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}

class RestaurantReviewPreview extends StatelessWidget {
  final int ratingCount;
  final double rating;
  final int? priceRate;

  RestaurantReviewPreview({
    required this.ratingCount,
    required this.rating,
    this.priceRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBarIndicator(
          rating: rating,
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
              ?.copyWith(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        horizontalSpaceSmall,
        Text('($ratingCount notes)'),
      ],
    );
  }
}

class RestaurantOpenHours extends StatelessWidget {
  final bool? status;
  final List<Map<String, dynamic>> weekHours;

  RestaurantOpenHours({this.status, required this.weekHours});

  Future<void> _showOpenHoursDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
          elevation: 0,
          title: Text(
            'Heures d\'ouverture',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                ),
          ),
          children: weekHours.map((day) {
            return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day['weekday'],
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    Text(
                      day['hours'],
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ));
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> openHoursDay = weekHours
        .elementAt(DateTime.now().weekday - 1)['hours']
        .toString()
        .split(' - ');

    bool isOpened = isOpen(weekHours);

    return GestureDetector(
      onTap: () {
        _showOpenHoursDialogue(context);
      },
      child: Container(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  isOpened ? 'Ouvert actuellement' : 'Fermé actuellement',
                  style: TextStyle(
                    color: isOpened ? Colors.green[500] : Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              horizontalSpaceTiny,
              Text(
                '--',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              horizontalSpaceTiny,
              Text(
                openHoursDay.length == 1
                    ? 'fermé'
                    : ('${openHoursDay[0]} - ${openHoursDay[1]} (Ajourd\'hui)'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontSize: 16),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantPresentationSkeleton extends StatelessWidget {
  const RestaurantPresentationSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ContentPlaceholder.block(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 20),
                          ContentPlaceholder.block(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 10),
                        ],
                      ),
                    ),
                    ContentPlaceholder.block(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 10),
                    ContentPlaceholder.block(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 10),
                    ContentPlaceholder.block(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 10),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
