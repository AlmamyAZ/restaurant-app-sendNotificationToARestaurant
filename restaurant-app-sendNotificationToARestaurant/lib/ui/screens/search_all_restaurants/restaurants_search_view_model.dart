// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/core/models/menu.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

class RestaurantsSearchViewModel extends BaseViewModel {
  List<Restaurant>? _restaurants;
  List<Restaurant>? get restaurants => _restaurants;

  List<MenuItem>? _menuItems;
  List<MenuItem>? get menuItems => _menuItems;

  Future searchRestaurants(String query) async {
    print('searchRestaurants');
    setBusyForObject(restaurants, true);
    _restaurants = await algoliaService.searchRestaurants(query);

    setBusyForObject(restaurants, false);
  }

  Future searchItems(String query, String restaurantId) async {
    print('searchItems');
    setBusyForObject(menuItems, true);
    _menuItems = await algoliaService.searchItems(query, restaurantId);
    setBusyForObject(menuItems, false);
  }

  String getDistance(GeoPoint position) {
    return mapService.distanceBetweenTwoLocation(
        position.latitude, position.longitude);
  }

  @override
  void dispose() {
    print('all restaurants disposed!!');
    super.dispose();
  }
}
