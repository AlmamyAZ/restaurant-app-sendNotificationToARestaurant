// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/core/services/upload_service.dart'; 
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant.dart';

class BottomTabsRestaurantViewModel extends ReactiveViewModel {
  final String? id;
  BottomTabsRestaurantViewModel({this.id});

  Cart? get restaurantCart => cartService.getCartByRestaurantId(id!);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [cartService];

  UploadService _uploadService = locator<UploadService>();

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  String getDistance(GeoPoint position) {
    return mapService.distanceBetweenTwoLocation(
      position.latitude,
      position.longitude,
    );
  }

  String getJoinKitchenSpeciality(kitchenSpecialities) {
    List kitchenSpecialitiesList = [];
    for (var kitchenSpeciality in kitchenSpecialities) {
      kitchenSpecialitiesList.add(kitchenSpeciality['name']);
    }

    return kitchenSpecialitiesList.join(', ');
  }

  List<Restaurant>? _sponsoredRestaurants;
  List<Restaurant>? get sponsoredRestaurants => _sponsoredRestaurants;

  List<Restaurant>? _relatedRestaurants;
  List<Restaurant>? get relatedRestaurants => _relatedRestaurants;

  int _currentTabIndex = 1;
  int get currentTabIndex => _currentTabIndex;

  bool _reverse = false;
  bool get reverse => _reverse;

  void setTabIndex(int value) {
    if (value < _currentTabIndex) {
      _reverse = true;
    }
    _currentTabIndex = value;
    notifyListeners();
  }

  Future share() async {
    String route = BottomTabsRestaurant.routeName;
    String dynamiclink = await dynamicLinkService.createDynamicLink(route, id!);
    Share.share(
      '${restaurant?.name} \n $dynamiclink',
      subject: dynamiclink,
    );
  }

  Future pushToAddReview(restaurantId, name) async {
    var result;
    if (authenticationService.currentUser == null) {
      result = await navigationService.navigateTo(Routes.loginView);
    } else {
      result = await navigationService.navigateTo(
        Routes.ratingReviewScreen,
        arguments: {'restaurantId': restaurantId, 'name': name},
      );
    }

    return result;
  }

  Future fetchRestaurant(String id) async {
    setBusyForObject(restaurant, true);
    _restaurant = await restaurantService.getRestaurantById(id);
    setBusy(false);
  }

  Future fetchSponsoredRestaurants() async {
    setBusyForObject(sponsoredRestaurants, true);
    _sponsoredRestaurants = await restaurantService.getSponsoredRestaurants();
    setBusyForObject(sponsoredRestaurants, false);
  }

  Future fetchRelatedRestaurants() async {
    setBusyForObject(relatedRestaurants, true);
    _relatedRestaurants = await restaurantService
        .getRelatedRestaurants(restaurant!.categoriesId!);
    setBusyForObject(relatedRestaurants, false);
  }

  Future pickPicture(String restaurantId) async {
    List<XFile> result = await _uploadService.imagePicker();

    if (result.isEmpty) return;

    navigationService.navigateTo(Routes.photoReviewScreen,
        arguments: {'asset': result[0], 'restaurantId': restaurantId});
  }

  bool isRestaurantCartEmpty() {
    return restaurantCart!.products!.isEmpty;
  }

  @override
  void dispose() {
    restaurantService.setRestaurantmenuInit(false);
    restaurantService.setRestaurantPhotosInit(false);
    restaurantService.setRestaurantReviewsInit(false);
    super.dispose();
  }
}
