// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_skeleton.dart';
import 'restaurant_card.dart';

class TopRestaurants extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Top Restaurants',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 215,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10),
                scrollDirection: Axis.horizontal,
                itemCount: model.busy(model.topRestaurants)
                    ? 5
                    : model.topRestaurants!.length,
                itemBuilder: (ctx, idx) {
                  Restaurant restaurant = model.busy(model.topRestaurants)
                      ? Restaurant()
                      : model.topRestaurants![idx];

                  return model.busy(model.topRestaurants)
                      ? RestaurantCardSkeleton()
                      : RestaurantCard(
                          id: restaurant.id!,
                          phoneNumber: restaurant.phoneNumber!,
                          adress: restaurant.adress!,
                          imageUrl: restaurant.imageUrl!,
                          imageHash: restaurant.imageHash!,
                          openHours: restaurant.openHours!,
                          name: restaurant.name!,
                          kitchenSpeciality: restaurant.kitchenSpeciality!,
                          rating: restaurant.rating!,
                          openStatus: restaurant.openStatus,
                        );
                },
              )),
        ],
      ),
    );
  }
}
