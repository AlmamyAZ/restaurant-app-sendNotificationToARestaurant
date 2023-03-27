// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

@singleton
class RestaurantsModel extends BaseViewModel {
  List<Restaurant>? _restaurants;
  List<Restaurant>? get restaurants => _restaurants;

  List<Restaurant>? _topRestaurants;
  List<Restaurant>? get topRestaurants => _topRestaurants;

  List<Restaurant>? _sponsoredRestaurants;
  List<Restaurant>? get sponsoredRestaurants => _sponsoredRestaurants;

  List<Restaurant>? _restaurantsForBundle;
  List<Restaurant>? get restaurantsForBundle => _restaurantsForBundle;

  List<Restaurant>? _restaurantsForDish;
  List<Restaurant>? get restaurantsForDish => _restaurantsForDish;

  List<Restaurant>? _restaurantsForCategory;
  List<Restaurant>? get restaurantsForCategory => _restaurantsForCategory;

  List<Restaurant>? _restaurantsForCollection;
  List<Restaurant>? get restaurantsForCollection => _restaurantsForCollection;

  Future fetchTopRestaurants() async {
    print('fetchTopRestaurants');
    setBusy(true);
    _topRestaurants = await restaurantService.getTopRestaurants();
    setBusy(false);
  }

  Future fetchDishRestaurants(id) async {
    print('fetchDishrestaurants');
    setBusy(true);
    _restaurantsForDish = await restaurantService.getDishRestaurants(id);
    setBusy(false);
  }

  Future fetchSponsoredRestaurants() async {
    print('fetchSponsoredRestaurants');
    setBusy(true);
    _sponsoredRestaurants = await restaurantService.getSponsoredRestaurants();
    setBusy(false);
  }

  Future fetchTopRestaurantsForBunble(String establishmentId) async {
    setBusy(true);
    _restaurantsForBundle =
        await restaurantService.getRestaurantsForBundle(establishmentId);
    setBusy(false);
  }

  Future fetchTopRestaurantsForCategory(String id) async {
    setBusy(true);
    _restaurantsForCategory =
        await restaurantService.getRestaurantsForCategory(id);
    setBusy(false);
  }

  Future fetchTopRestaurantsForCollection(restaurantIds) async {
    setBusy(true);
    _restaurantsForCollection =
        await restaurantService.getRestaurantsForCollection(restaurantIds);
    setBusy(false);
  }

  @override
  void dispose() {
    print('restaurants disposed!!');
    super.dispose();
  }
}
