// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';

class FoodDescription extends ViewModelWidget<FoodViewModel> {
  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          content,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, FoodViewModel model) {
    return model.busy(model.dish)
        ? FoodDescritionSkeleton()
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  'Description du plat',
                  model.dish!.description!,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildSection(
                  context,
                  'Ingredients principaux',
                  model.dish!.ingredients!,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }
}

class FoodDescritionSkeleton extends StatelessWidget {
  const FoodDescritionSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 13,
                  topSpacing: 10),
              ContentPlaceholder.block(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 12,
              ),
              ContentPlaceholder.block(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 13,
              ),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 12,
                  bottomSpacing: 0),
              // ContentPlaceholder.block(
              //     width: MediaQuery.of(context).size.width * 0.6, height: 10),
            ],
          )),
    );
  }
}
