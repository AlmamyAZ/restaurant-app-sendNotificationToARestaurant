// Package imports:
import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

@LazySingleton()
class StartupViewModel extends BaseViewModel {
  bool _animationComplete = false;
  String? _destinationRoute;
  dynamic _destinationArguments;

  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> get markers => _markers;

  LatLng _initialPosition = const LatLng(9.5501587, -13.6565422);
  LatLng get initialPosition => _initialPosition;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  // Future initialise() async {
  //   await launchLocationProcess();
  //   print('hello');
  //   launchAuthProcess();
  // }

  Future launchLocationProcess() async {
    try {
      await mapService.getLocation();
    } catch (e) {
      print('error when getting user location $e');
      await navigationService.navigateTo(Routes.startupMapSelectionView);
    }
  }

  Future launchAuthProcess() async {
    var hasLoggedInUser = authenticationService.isUserLoggedIn();
    notificationService.requestPermission();
    authenticationService.addUserListener();
    notificationService.addTokenListener();
    notificationService.getFcmToken();
    notificationService.configure();

    dynamic deepLink = await dynamicLinkService.handleDynamicLinks();
    if (deepLink != null) return;
    if (hasLoggedInUser && !authenticationService.verifyUnVerifiedEmail()) {
      await _replaceWith(route: Routes.bottomTabsApp);
    } else if (hasLoggedInUser &&
        authenticationService.verifyUnVerifiedEmail()) {
      await authenticationService.logOut();
      await _replaceWith(route: Routes.emailValidationView);
    } else {
      await _replaceWith(route: Routes.onBoardingPage);
    }
  }

  Future<bool> onBackPressed() async {
    print('pop');
    return false;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void initialiseMap() {
    _markers.add(
      Marker(markerId: MarkerId('cameraLocation'), position: _initialPosition),
    );
    notifyListeners();
  }

  void getLocation() {
    mapService.setMapCurrentLocation(mapController!);
  }

  void updateMarkerPosition(CameraPosition cameraPosition) {
    _markers.removeWhere(
      (marker) => marker.markerId == MarkerId('cameraLocation'),
    );

    _markers.add(Marker(
      markerId: MarkerId('cameraLocation'),
      position: cameraPosition.target,
    ));
    notifyListeners();
  }

  Future _replaceWith({String? route, dynamic arguments}) async {
    var hasDestinationRoute = _destinationRoute != null;
    var hasDestinationArguments = _destinationArguments != null;

    // Set the route only if we don't have a route
    if (!hasDestinationRoute) {
      _destinationRoute = route;
    }

    // set the arguments only if we don't have arguments
    if (!hasDestinationArguments) {
      _destinationArguments = arguments;
    }

    // navigate only if the animation is complete
    if (_animationComplete && _destinationRoute != null) {
      await navigationService.clearStackAndShow(
        _destinationRoute!,
        arguments: _destinationArguments,
      );
    }
  }

  Future indicateAnimationComplete() async {
    _animationComplete = true;
    await _replaceWith();
  }

  @override
  void dispose() {
    print('StartupViewModel disposed');
    super.dispose();
  }
}
