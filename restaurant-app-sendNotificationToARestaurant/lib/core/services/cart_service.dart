// Package imports:
import 'package:injectable/injectable.dart';
// import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';

/// The service responsible for networking requests
@lazySingleton
class CartService with ReactiveServiceMixin {
  CartService() {
    print('** listening CartService begin');
    listenToReactiveValues([_restaurantCarts]);
  }

  var uuid = Uuid();

  ReactiveList<Cart?> _restaurantCarts = ReactiveList<Cart?>();
  List<Cart?> get restaurantCarts => _restaurantCarts;

  Cart? getCartByRestaurantId(String restaurantId) {
    return _restaurantCarts.singleWhere((cart) {
      return cart?.restaurantId == restaurantId;
    }, orElse: () => Cart(products: []));
  }

  void addCartToRestaurantCarts(Map<String, dynamic> cartData) {
    Cart? cart = verifyCartExistance(cartData['restaurantId']);
    updateRestaurantCarts(cart, cartData);
  }

  void removeCartToRestaurantCarts(String restaurantId) {
    Cart? cart = verifyCartExistance(restaurantId);
    if (cart != null) _restaurantCarts.remove(cart);
  }

  Cart? verifyCartExistance(String restaurantId) {
    return _restaurantCarts.firstWhere(
        (cart) => cart?.restaurantId == restaurantId,
        orElse: () => null);
  }

  void updateRestaurantCarts(Cart? cart, Map<String, dynamic> cartData) {
    Product product = Product(
        id: cartData['item'].id,
        alias: cartData['item'].alias,
        price: cartData['item'].price,
        quantity: cartData['quantity']);
    int cartIndex = -1;

    if (cart != null) {
      // Get the cart index in the list
      cartIndex = _restaurantCarts.indexOf(cart);
      // Update the cart products
      cart = addProductToCart(cart, product);
    } else {
      // Create a new cart
      cart = Cart(
          id: uuid.v1(),
          userId: firebaseAuth.currentUser?.uid,
          restaurantId: cartData['restaurantId'],
          products: [product],
          total: 0);
    }

    insertCart(cart..computeTotal(), cartIndex);
  }

  Cart addProductToCart(Cart cart, Product product) {
    int index =
        cart.products!.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      cart.products![index].quantity =
          cart.products![index].quantity! + product.quantity!;
      cart.products!.replaceRange(index, index + 1, [cart.products![index]]);
    } else {
      cart.products!.add(product);
    }

    return cart;
  }

  void insertCart(Cart cart, int index) {
    if (index == -1)
      _restaurantCarts.add(cart);
    else {
      _restaurantCarts.removeAt(index);
      _restaurantCarts.add(cart);
    }
  }

  void refreshCartByRestaurantId(String restaurantId) {
    Cart? cart = verifyCartExistance(restaurantId);
    int cartIndex = _restaurantCarts.indexOf(cart!);
    insertCart(cart..computeTotal(), cartIndex);

    if (cart.products!.isEmpty) {
      removeCartToRestaurantCarts(restaurantId);
      return;
    }
  }
}
