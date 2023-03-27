// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/widgets/cart/views/restaurant_cart_options_view.dart';
import 'package:restaurant_app/ui/widgets/cart/views/restaurant_cart_update_view.dart';

@injectable
class RestaurantCartViewModel extends ReactiveViewModel {
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController get noteController => _noteController;
  GlobalKey<FormState> get formKey => _formKey;

  Cart? get restaurantCart =>
      cartService.getCartByRestaurantId(restaurantService.currentRestaurantId!);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [cartService];

  void setOrderDeliveryState(bool state) {
    restaurantCart?.isDelivery = state;
    cartService.refreshCartByRestaurantId(restaurantCart!.restaurantId!);
  }

  void setOrderTime(OrderTime orderTime, String orderHour, String orderDay) {
    restaurantCart?.orderTime = orderTime;
    restaurantCart?.orderDeliveryDay = orderDay;
    restaurantCart?.orderDeliveryTime = orderHour;
    cartService.refreshCartByRestaurantId(restaurantCart!.restaurantId!);
  }

  void setOrderNote(String orderNote) {
    restaurantCart?.orderNote = orderNote;
    cartService.refreshCartByRestaurantId(restaurantCart!.restaurantId!);
    navigationService.back();
  }

  void handleOrderTime(DateTime time) {
    notifyListeners();
  }

  void updateCartElement(Product element, int quantity) {
    int elementIndex = restaurantCart!.products!.indexOf(element);
    updateElement(quantity, elementIndex, element);
    bool isEmptyCart = restaurantCart!.products!.isEmpty;
    cartService.refreshCartByRestaurantId(restaurantCart!.restaurantId!);

    if (isEmptyCart) navigationService.back();
  }

  void updateElement(int quantity, int elementIndex, Product element) {
    if (quantity > 0) {
      restaurantCart?.products?.replaceRange(
        elementIndex,
        elementIndex + 1,
        [
          Product(
            id: element.id,
            price: element.price,
            alias: element.alias,
            quantity: quantity,
          ),
        ],
      );
    } else if (quantity == 0) {
      restaurantCart?.products?.removeAt(elementIndex);
    }
  }

  void showOrderOptions(ctx, RestaurantCartViewModel model) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      context: ctx,
      builder: (_) {
        return RestaurantCartOptionsView(model: model);
      },
    );
  }

  void showUpdateElement(ctx, RestaurantCartViewModel model, Product element) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      context: ctx,
      builder: (_) {
        return RestaurantCartUpdateView(model: model, element: element);
      },
    );
  }

  void navigateToOrderNoteScreen(RestaurantCartViewModel model) async {
    await navigationService.navigateTo(Routes.orderNoteScreen,
        arguments: model);
  }

  void removeCart() {
    cartService.removeCartToRestaurantCarts(restaurantCart!.restaurantId!);
    navigationService.back();
  }

  void navigateToCheckout() {
    navigationService.navigateTo(Routes.cartCheckoutScreen, arguments: this);
  }

  bool isROpen() {
    List<Map<String, dynamic>>? currentRestaurantOpenHours =
        restaurantService.currentRestaurantOpenHours;

    if (currentRestaurantOpenHours == null) return false;
    return isOpen(currentRestaurantOpenHours);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
