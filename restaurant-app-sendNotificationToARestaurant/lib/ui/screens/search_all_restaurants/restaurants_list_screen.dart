// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/filters_list.dart';
import '../../widgets/restaurant/views/restaurants_list.dart';
import '../../widgets/uielements/searchbar.dart';

class RestaurantsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchBar(),
        elevation: 0,
      ),
      body: ViewModelBuilder<AllRestaurantsViewModel>.reactive(
        viewModelBuilder: () => locator<AllRestaurantsViewModel>(),
        onModelReady: (model) {
          model.fetchAllRestaurants();
          model.fetchAllCategories();
        },
        disposeViewModel: false,
        fireOnModelReadyOnce: true,
        builder: (context, model, child) => SafeArea(
          child: Column(
            children: [
              FiltersList(),
              RestaurantsList(),
            ],
          ),
        ),
      ),
    );
  }
}
