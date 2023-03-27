// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/dish_restaurants.dart';
import '../../widgets/food/views/food_description.dart';
import '../../widgets/food/views/food_header.dart';
import '../../widgets/uielements/section_title.dart';

class FoodDetailsScreen extends StatelessWidget {
  static const String routeName = '/food-details';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> foodItem =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        body: ViewModelBuilder<FoodViewModel>.reactive(
      viewModelBuilder: () => FoodViewModel(dishId: foodItem['id']),
      onModelReady: (model) {
        model.fetchDisheById();
        model.fetchDishRestaurants();
      },
      builder: (context, model, child) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              foodItem['name'],
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            flexibleSpace: FoodHeader(foodItem: foodItem),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 250,
            elevation: 0,
            pinned: true,
            toolbarTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ).bodyText2,
            titleTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ).headline6,
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  FoodDescription(),
                  Divider(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [SectionTitle(title: 'Où en trouver')],
              ),
            ),
          ),
          DishRestaurants()
        ],
      ),
    ));
  }
}
