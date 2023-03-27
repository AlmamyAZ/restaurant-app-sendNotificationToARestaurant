// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_skeleton.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/restaurants.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'restaurant_card.dart';

class RestaurantsDisplayListCategory extends StatelessWidget {
  final String id;

  const RestaurantsDisplayListCategory({
    Key? key,
    required this.id,
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
        onModelReady: (model) => model.fetchTopRestaurantsForCategory(id),
        builder: (context, model, child) {
          return !model.isBusy && model.restaurantsForCategory!.isEmpty
              ? EmptyList(
                  sign: Icon(
                    Icons.no_meals,
                    color: Colors.grey[400],
                    size: 150,
                  ),
                  message: 'Rien à afficher pour le moment',
                )
              : GridView.builder(
                  itemBuilder: (ctx, idx) {
                    Restaurant restaurant = model.isBusy
                        ? Restaurant()
                        : model.restaurantsForCategory![idx];
                    return model.isBusy
                        ? RestaurantCardSkeleton(
                            grid: true,
                          )
                        : RestaurantCard(
                            grid: true,
                            phoneNumber: restaurant.phoneNumber!,
                            openHours: restaurant.openHours!,
                            id: restaurant.id!,
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
                      model.isBusy ? 5 : model.restaurantsForCategory!.length,
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
