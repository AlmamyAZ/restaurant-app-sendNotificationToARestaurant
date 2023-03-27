// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_skeleton.dart';
import 'restaurant_card.dart';

class SponsoredRestaurantsGrid
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  const SponsoredRestaurantsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    //450 is the height of one grid item
    var aspectRatio = columnWidth / 500; //TODO: make this dynamic

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int idx) {
            Restaurant restaurant = model.busy(model.sponsoredRestaurants)
                ? Restaurant()
                : model.sponsoredRestaurants![idx];
            return model.busy(model.sponsoredRestaurants)
                ? RestaurantCardSkeleton(
                    grid: true,
                  )
                : RestaurantCard(
                    grid: true,
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
          childCount: model.busy(model.sponsoredRestaurants)
              ? 4
              : model.sponsoredRestaurants!.length,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 1.8,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 15,
          mainAxisSpacing: 5,
        ),
      ),
    );
  }
}
