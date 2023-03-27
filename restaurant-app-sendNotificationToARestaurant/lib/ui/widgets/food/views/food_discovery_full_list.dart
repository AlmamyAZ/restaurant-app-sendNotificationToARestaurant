// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/dish.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/food/skeletons/food_item_skeleton.dart';
import 'food_item.dart';

class FoodDiscoveryFullList extends ViewModelWidget<FoodViewModel> {
  const FoodDiscoveryFullList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, FoodViewModel model) {
    var maxWidth = 500.0;
    var numColumns = orientationIsPortrait(context) ? 2 : 3;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    //450 is the height of one grid item
    var gridItemHeigh = orientationIsPortrait(context) ? 450 : 320;
    var aspectRatio = columnWidth / gridItemHeigh;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        itemBuilder: (BuildContext context, int idx) {
          Dish dish = model.busy(model.dishes) ? Dish() : model.dishes[idx];
          return model.busy(model.dishes)
              ? FoodItemSkeleton()
              : FoodItem(
                  id: dish.id!,
                  foodGenericId: dish.foodGenericId!,
                  name: dish.name!,
                  likerCount: dish.likerCount!,
                  speciality: dish.speciality!,
                  description: dish.description!,
                  ingredients: dish.ingredients!,
                  createdAt: dish.createdAt!,
                  imageUrl: dish.imageUrl!,
                  imageHash: dish.imageHash!,
                );
        },
        itemCount: model.busy(model.dishes) ? 4 : model.dishes.length,
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
