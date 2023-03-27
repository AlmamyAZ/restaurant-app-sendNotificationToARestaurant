// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/dish.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

@injectable // Add decoration
class FoodViewModel extends StreamViewModel {
  final String? dishId;
  FoodViewModel({
    this.dishId,
  });

  List<Dish> _dishes = [];
  List<Dish> get dishes => _dishes;

  // stream start

  bool _isLiked = false;

  bool get isLiked => _isLiked;

  @override
  void onData(data) {
    setBusy(true);
    _isLiked = data == null ? false : data['state'];
    setBusy(false);
  }

  String getDistance(GeoPoint position) {
    return mapService.distanceBetweenTwoLocation(
        position.latitude, position.longitude);
  }

  @override
  Stream get stream => dishService.listenToDishLikestream(dishId);

  // Stream End

  Dish? _dish;
  Dish? get dish => _dish;

  List<Restaurant>? _restaurantsForDish;
  List<Restaurant>? get restaurantsForDish => _restaurantsForDish;

  Future fetchDisheById() async {
    print('fetchDishes');
    setBusyForObject(dish, true);
    _dish = await dishService.getDishById(dishId!);
    setBusyForObject(dish, false);
  }

  Future fetchDishes() async {
    print('fetchDishes');
    setBusyForObject(dishes, true);
    _dishes = await dishService.getDishes();
    setBusyForObject(dishes, false);
  }

  Future getAllDishes() async {
    print('fetchAllDishes');
    setBusyForObject(dishes, true);
    _dishes = await dishService.getAllDishes();
    setBusyForObject(dishes, false);
  }

  Future likeDish() async {
    try {
      bool state = isLiked;
      //  To notify that a user is know connected
      await authenticationService.redirectIfNotConnetedWithResult();

      await dishService.likeDish(dishId!, state);
      setBusy(true);
      state
          ? _dish!.likerCount = _dish!.likerCount! - 1
          : _dish!.likerCount = _dish!.likerCount! + 1;
      setBusy(false);
    } catch (e) {
      print(e);
    }
  }

  Future fetchDishRestaurants() async {
    print('fetchDishrestaurants');
    setBusyForObject(restaurantsForDish, true);
    _restaurantsForDish = await restaurantService.getDishRestaurants(dishId);
    setBusyForObject(restaurantsForDish, false);
  }

  @override
  void dispose() {
    print('view model food disposed');
    super.dispose();
  }
}
