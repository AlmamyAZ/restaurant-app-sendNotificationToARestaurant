// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_skeleton.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/restaurants.dart';
import 'restaurant_card.dart';

class RestaurantsDisplayListCollection extends StatelessWidget {
  final List<String> restaurantsIds;
  const RestaurantsDisplayListCollection({
    Key? key,
    required this.restaurantsIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    //450 is the height of one grid item
    var aspectRatio = columnWidth / 450;

    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 0),
      child: ViewModelBuilder<RestaurantsModel>.reactive(
        viewModelBuilder: () =>
            RestaurantsModel(), // should we inject it with GetIt ?
        onModelReady: (model) =>
            model.fetchTopRestaurantsForCollection(restaurantsIds),
        builder: (context, model, child) {
          return GridView.builder(
            itemBuilder: (ctx, idx) {
              Restaurant restaurant = model.isBusy
                  ? Restaurant()
                  : model.restaurantsForCollection![idx];
              return model.isBusy
                  ? RestaurantCardSkeleton(
                      grid: true,
                    )
                  : RestaurantCard(
                      grid: true,
                      openHours: restaurant.openHours!,
                      id: restaurant.id!,
                      phoneNumber: restaurant.phoneNumber!,
                      adress: restaurant.adress!,
                      imageUrl: restaurant.imageUrl!,
                      imageHash: restaurant.imageHash!,
                      name: restaurant.name!,
                      kitchenSpeciality: restaurant.kitchenSpeciality!,
                      rating: restaurant.rating!,
                      openStatus: restaurant.openStatus,
                    );
            },
            itemCount:
                model.isBusy ? 8 : model.restaurantsForCollection?.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 1.8,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        },
      ),
    );
  }
}
