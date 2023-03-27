// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/menu.dart';

@singleton
class MenuModel extends BaseViewModel {
  Menu? _menu;
  Menu? get menu => _menu;

  Future fetchMenuByRestaurantId(String id) async {
    if (!restaurantService.restaurantmenuInit) {
      setBusy(true);
      _menu = await restaurantService.getMenuByRestaurantId(id);

      setBusy(false);
      restaurantService.setRestaurantmenuInit(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
