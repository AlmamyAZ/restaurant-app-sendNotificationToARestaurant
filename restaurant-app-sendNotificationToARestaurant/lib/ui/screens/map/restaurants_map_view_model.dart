// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

@singleton // Add decoration
class RestaurantsMapViewModel extends BaseViewModel {
  LatLng _position = const LatLng(9.5501587, -13.6565422);

  bool showSatelitte = false;

  ItemScrollController _scrollController = new ItemScrollController();
  ItemScrollController get scrollController => _scrollController;

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  LatLng get position => _position;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  void initMap() {
    getLocation();
  }

  void setShowSatelitte() {
    showSatelitte = !showSatelitte;
    notifyListeners();
  }

  String getDistance(Restaurant restaurant) {
    GeoPoint position = restaurant.position!;
    return mapService.distanceBetweenTwoLocation(
        position.latitude, position.longitude);
  }

  bool _showRestaurants = false;
  bool get showRestaurants => _showRestaurants;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> get markers => _markers;

  var _currentLocation;
  get currentLocation => _currentLocation;

  Stream<List<DocumentSnapshot>>? _myStream;
  Stream<List<DocumentSnapshot>>? get myStream => _myStream;

  void getLocation() {
    mapService.setMapCurrentLocation(mapController);
  }

  void setCurrentRestaurant(Restaurant restaurant) {
    int index =
        restaurants.indexWhere((element) => element.id == restaurant.id!);
    print('hello : $index');
    if (scrollController.isAttached) {
      _scrollController.scrollTo(
          index: index, duration: Duration(milliseconds: 500));
    }
  }

  void setShowRestaurant(bool state, {Restaurant? restaurant}) {
    if (restaurant == null) return;
    setBusy(true);
    _showRestaurants = state;
    setBusy(false);
    setCurrentRestaurant(restaurant);
  }

  void hideCard(latLng) {
    setShowRestaurant(false);
  }

  void updatePosition(CameraPosition cameraPosition) {
    _position = cameraPosition.target;
  }

  List<Restaurant> serializeRestaurants(
      List<DocumentSnapshot> restaurantsDocumentsSnapshot) {
    return restaurantsDocumentsSnapshot
        .map((snapshot) {
          return restaurantService.serializeRestaurant(
              snapshot.data() as Map<String, dynamic>, snapshot.id);
        })
        .where((mappedItem) => mappedItem.name != null)
        .toList();
  }

  void searchRestaurant() async {
    double radius = MAP_SEARCH_RADIUS / 1000;

    GeoFirePoint center = mapService.convertCoordinatesToGeoFire(position);

    _myStream = mapService.getRestaurantArround(radius, center)
        as Stream<List<DocumentSnapshot<Object?>>>?;

    myStream?.listen((List<DocumentSnapshot> documentList) {
      setBusy(true);
      _restaurants = serializeRestaurants(documentList);
      _markers = mapService.getAllMarkers(
          _restaurants,
          (Restaurant restaurant) =>
              setShowRestaurant(true, restaurant: restaurant));
      print('markers === $markers');
      setBusy(true);
    });
  }

  void onMapCreated(GoogleMapController controller) {
    print('map created ');
    _mapController = controller;
    searchRestaurant();
  }

  @override
  void dispose() {
    print('home disposed');
    super.dispose();
  }
}
