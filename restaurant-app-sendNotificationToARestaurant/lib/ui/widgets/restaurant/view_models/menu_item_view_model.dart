// Package imports:
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:share_plus/share_plus.dart';
// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/menu.dart';

@singleton
class MenuItemViewModel extends BaseViewModel {
  MenuItem? _menuItem;
  MenuItem? get menuItem => _menuItem;

  String? _menuSectionId;
  String? get menuSectionId => _menuSectionId;

  int _orderQuantity = 1;
  int get orderQuantity => _orderQuantity;

  Future fetchMenuByRestaurantId(String id) async {}

  void handleItemQuantityChange(int unit) {
    if (_orderQuantity + unit < 1) return;
    print('menu Item > handleItemQuantityChange');
    setBusyForObject(orderQuantity, true);
    _orderQuantity += unit;
    setBusyForObject(orderQuantity, false);
  }

  void setMenuItemData(MenuItem menuItemData) {
    _menuItem = menuItemData;
    notifyListeners();
  }

  void setMenuSectionId(String id) {
    _menuSectionId = id;
    notifyListeners();
  }

  void addMenuItemToCart(String restaurantId) {
    cartService.addCartToRestaurantCarts({
      'restaurantId': restaurantId,
      'item': _menuItem,
      'quantity': _orderQuantity,
    });

    navigationService.back();
  }

  Future share(Map<String, dynamic> arguments) async {
    String route = Routes.menuItemDetailsScreen;
    String dynamiclink =
        await dynamicLinkService.createDynamicLink(route, 'arguments');
    Share.share(
      '${menuItem?.alias} \n $dynamiclink',
      subject: dynamiclink,
    );
  }

  @override
  void dispose() {
    print('menu Item disposed!!');
    super.dispose();
  }
}
