// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_large_skeleton.dart';
import 'restaurant_card_large.dart';

class SponsoredRestaurants extends ViewModelWidget<HomeViewModel> {
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
              'Restaurants Sponsorts',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 178,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10),
                scrollDirection: Axis.horizontal,
                itemCount: model.busy(model.sponsoredRestaurants)
                    ? 5
                    : model.sponsoredRestaurants!.length,
                itemBuilder: (ctx, idx) {
                  Restaurant restaurant = model.busy(model.sponsoredRestaurants)
                      ? Restaurant()
                      : model.sponsoredRestaurants![idx];
                  return model.busy(model.sponsoredRestaurants)
                      ? RestaurantCardLargeSkeleton()
                      : RestaurantCardLarge(
                          id: restaurant.id!,
                          adress: restaurant.adress!,
                          imageUrl: restaurant.imageUrl!,
                          imageHash: restaurant.imageHash!,
                          name: restaurant.name!,
                          openHours: restaurant.openHours!,
                          kitchenSpeciality: restaurant.kitchenSpeciality!,
                          rating: restaurant.rating!,
                          openStatus: restaurant.openStatus,
                        );
                },
              ))
        ],
      ),
    );
  }
}
