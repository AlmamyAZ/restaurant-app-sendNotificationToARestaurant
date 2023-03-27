// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import 'filter_element_all_restaurants.dart';

class FiltersList extends ViewModelWidget<AllRestaurantsViewModel> {
  @override
  Widget build(BuildContext context, AllRestaurantsViewModel model) {
    List? categories = model.busy(model.categories) ? [] : model.categories;
    return Container(
      alignment: Alignment.center,
      height: 55,
      child: ListView(
        children: [
          FilterElementAllRestaurants(
            label: 'filtrer',
            setIndexHandler: model.setSelectedIndex,
            selectedIndex: model.selectedIndex,
            idx: 0,
          ),
          FilterElementAllRestaurants(
            label: 'Tout',
            setIndexHandler: model.setSelectedIndex,
            selectedIndex: model.selectedIndex,
            idx: 1,
          ),
          ...categories!
              .asMap()
              .map((key, value) => MapEntry(
                  key,
                  FilterElementAllRestaurants(
                    label: categories[key].name,
                    setIndexHandler: model.setSelectedIndex,
                    selectedIndex: model.selectedIndex,
                    idx: key + 2,
                  )))
              .values
              .toList()
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
