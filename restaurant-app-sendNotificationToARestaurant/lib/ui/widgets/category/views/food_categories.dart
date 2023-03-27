// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/widgets/category/skeletons/food_categories_card_skeleton.dart';
import '../../../../core/models/category.dart';
import 'food_cartegories_card.dart';

class FoodCategories extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10),
              scrollDirection: Axis.horizontal,
              itemCount: model.busy(model.categoriesHome)
                  ? 5
                  : model.categoriesHome.length,
              itemBuilder: (ctx, idx) {
                Category category = model.busy(model.categoriesHome)
                    ? Category.noRequired()
                    : model.categoriesHome[idx];
                return model.busy(model.categoriesHome)
                    ? FoodCategoriesCardSkeleton()
                    : FoodCategoriesCard(
                        id: category.id!,
                        imageHash: category.imageHash!,
                        name: category.name!,
                        imgUrl: category.imgUrl!);
              },
            ),
          )
        ],
      ),
    );
  }
}
