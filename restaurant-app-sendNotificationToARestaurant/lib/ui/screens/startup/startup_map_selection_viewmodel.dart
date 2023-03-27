// Package imports:
import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:stacked/stacked.dart';

// @lazySingleton
class StartupMapSelectionViewModel extends BaseViewModel {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> get markers => _markers;

  LatLng _initialPosition = const LatLng(9.5501587, -13.6565422);
  LatLng get initialPosition => _initialPosition;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  void initialiseMap() {
    _markers.add(
      Marker(markerId: MarkerId('cameraLocation'), position: _initialPosition),
    );
    notifyListeners();
  }

  void confirmePosition() async {
    debugPrint("initialise 👄👄👄👄👄");
    mapService.updateLocation(markers.single.position);
    navigationService.back();
  }

  Future<bool> onBackPressed() async {
    print('pop');
    exit(0);
    // return false;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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

  @override
  void dispose() {
    super.dispose();
  }
}
