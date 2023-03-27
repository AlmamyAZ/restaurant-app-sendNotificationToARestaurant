// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/feeds_restaurant_skeleton.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurant_card_feeds.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class FeedsRestaurant extends ViewModelWidget<HomeViewModel> {
  const FeedsRestaurant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    var maxWidth = orientationIsPortrait(context)
        ? screenWidth(context)
        : screenWidth(context) / 2;
    var numColumns = orientationIsPortrait(context) ? 1 : 2;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    //450 is the height of one grid item
    var gridItemHeigh = orientationIsPortrait(context) ? 125 : 160;
    var aspectRatio = columnWidth / gridItemHeigh;

    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int idx) {
            Restaurant restaurant = model.busy(model.feedsRestaurants)
                ? Restaurant()
                : model.feedsRestaurants![idx];

            return model.busy(model.feedsRestaurants)
                ? FeedsRestaurantSkeleton()
                : RestaurantCardFeeds(
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
                    distance: model.getDistance(restaurant.position!),
                  );
          },
          childCount: model.busy(model.feedsRestaurants)
              ? 10
              : model.feedsRestaurants!.length,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / numColumns,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
