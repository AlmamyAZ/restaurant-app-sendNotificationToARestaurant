// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';
import 'package:restaurant_app/ui/widgets/food/views/food_discovery_full_list.dart';

// Project imports:
import 'package:stacked/stacked.dart';

class DishesDisplayScreenDiscoveries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FoodViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Espace decouverte',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: Container(
          child: FoodDiscoveryFullList(),
        ),
      ),
      viewModelBuilder: () => FoodViewModel(),
      onModelReady: (model) {
        model.getAllDishes();
      },
    );
  }
}
