// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_horizontal_skeleton.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'restaurant_card_horizontal.dart';

class RestaurantsList extends ViewModelWidget<AllRestaurantsViewModel> {
  @override
  Widget build(BuildContext context, AllRestaurantsViewModel model) {
    bool isListEmpty =
        !model.busy(model.restaurants) && model.restaurants?.length == 0;
    return Expanded(
      child: isListEmpty
          ? EmptyList(
              sign: Icon(
                Icons.no_meals,
                color: Colors.grey[400],
                size: 150,
              ),
              message: 'Rien à afficher pour le moment',
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: model.busy(model.restaurants)
                  ? 10
                  : model.restaurants?.length,
              itemBuilder: (ctx, idx) {
                Restaurant restaurant = model.busy(model.restaurants)
                    ? Restaurant()
                    : model.restaurants![idx];
                return model.busy(model.restaurants)
                    ? RestaurantCardHorizontalSkeleton()
                    : RestaurantCardHorizontal(
                      phoneNumber: restaurant.phoneNumber!,
                        kitchenSpeciality: restaurant.kitchenSpeciality!,
                        adress: restaurant.adress!,
                        id: restaurant.id!,
                        imageHash: restaurant.imageHash!,
                        imageUrl: restaurant.imageUrl!,
                        name: restaurant.name!,
                        openHours: restaurant.openHours!,
                        rating: restaurant.rating!,
                        openStatus: restaurant.openStatus,
                        ratingCount: restaurant.ratingCount!,
                        getDistance: () =>
                            model.getDistance(restaurant.position!),
                      );
              },
            ),
    );
  }
}
