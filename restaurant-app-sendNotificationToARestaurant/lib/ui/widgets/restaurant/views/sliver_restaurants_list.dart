// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_horizontal_skeleton.dart';
import 'restaurant_card_horizontal.dart';

class SliverRelatedRestaurantsList
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  const SliverRelatedRestaurantsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int idx) {
            Restaurant restaurant = model.busy(model.relatedRestaurants)
                ? Restaurant()
                : model.relatedRestaurants![idx];
            return model.busy(model.relatedRestaurants)
                ? RestaurantCardHorizontalSkeleton()
                : RestaurantCardHorizontal(
                    id: restaurant.id!,
                    phoneNumber: restaurant.phoneNumber!,
                    adress: restaurant.adress!,
                    imageUrl: restaurant.imageUrl!,
                    imageHash: restaurant.imageHash!,
                    name: restaurant.name!,
                    openHours: restaurant.openHours!,
                    ratingCount: restaurant.ratingCount!,
                    kitchenSpeciality: restaurant.kitchenSpeciality!,
                    rating: restaurant.rating!,
                    openStatus: restaurant.openStatus,
                    getDistance: () => model.getDistance(restaurant.position!),
                  );
          },
          childCount: model.busy(model.relatedRestaurants)
              ? 5
              : model.relatedRestaurants!.length,
        ),
      ),
    );
  }
}
