// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/category.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

@singleton
class AllRestaurantsViewModel extends BaseViewModel {
  int selectedIndex = 1;
  int selectedFilter = 0;

  List<Restaurant>? _restaurants;
  List<Restaurant>? get restaurants => _restaurants;

  List<Category>? _categories;
  List<Category>? get categories => _categories;

  Future fetchRestaurantsByCategory() async {
    print('fetchRestaurantsByCategory $selectedIndex');
    setBusyForObject(restaurants, true);
    if (selectedIndex == 1) {
      fetchAllRestaurants();
    } else {
      String categoryId = categories![selectedIndex - 2].id!;
      _restaurants =
          await restaurantService.getRestaurantsForCategory(categoryId);
    }

    setBusyForObject(restaurants, false);
  }

  Future fetchAllRestaurants() async {
    print('fetchAllRestaurants');
    setBusyForObject(restaurants, true);
    _restaurants = await restaurantService.getAllRestaurants();
    setBusyForObject(restaurants, false);
  }

  String getDistance(GeoPoint position) {
    return mapService.distanceBetweenTwoLocation(
        position.latitude, position.longitude);
  }

  void setSelectedIndex(index) {
    print('setSelectedIndex');
    setBusyForObject(selectedIndex, false);
    selectedIndex = index;
    fetchRestaurantsByCategory();
    setBusyForObject(selectedIndex, true);
  }

  void setSelectedFilter(index) {
    print('setSelectedIndex');
    selectedFilter = index;
    fetchAllRestaurants();
    setBusyForObject(selectedFilter, true);
  }

  Future fetchAllCategories() async {
    print('fetchAllCategories');
    setBusyForObject(categories, true);
    _categories = await categoriesService.getCategoriesHome();
    setBusyForObject(categories, false);
  }

  @override
  void dispose() {
    print('all restaurants disposed!!');
    super.dispose();
  }
}
