// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

@singleton // Add decoration
class RestaurantViewModel extends BaseViewModel {

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  Future fetchRestaurant(String id) async {
    setBusy(true);
    _restaurant = await restaurantService.getRestaurantById(id);
    setBusy(false);
  }

  @override
  void dispose() {
    print('restaurant view disposed!!');
    super.dispose();
  }
}
