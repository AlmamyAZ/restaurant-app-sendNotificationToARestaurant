// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

@singleton
class MapService {
  GeoFlutterFire _geo = GeoFlutterFire();
  // Geolocator _geolocator = Geolocator();
  final String restaurantCoordinatesField = 'adress.position';

  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;

  MapService() {
    print('map initialize');
    setMarkerIcon();
  }

  // StreamSubscription<Position> positionStreamSubscription;
  updateLocation(LatLng location) {
    _userLocation = location;
  }

  getPostion() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: Duration(minutes: 1),
    ).listen((position) {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  double getDistance(endLatitude, endLongitude) {
    return Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      endLatitude,
      endLongitude,
    );
  }

//
  String distanceBetweenTwoLocation(endLatitude, endLongitude) {
    double distance = getDistance(endLatitude, endLongitude);
    if (distance >= 1000) return "~ ${(distance / 1000).toStringAsFixed(1)} Km";
    return '~ ${distance.toStringAsFixed(0)} m';
  }

  // double getDistanceBeetweenTwoLocation(endLatitude, endLongitude) {
  //   double distance = getDistance(endLatitude, endLongitude);
  //   if (distance >= 1000) return distance / 1000;
  //   return distance;
  // }
  double getDistanceBeetweenTwoLocation(GeoPoint position, LatLng userAdress) {
    // LatLng userAdress = orderAdress!.latLng!;

    return Geolocator.distanceBetween(
          userAdress.latitude,
          userAdress.longitude,
          position.latitude,
          position.longitude,
        ) /
        1000;
  }

  BitmapDescriptor? _markerIcon;

  final CollectionReference<Map<String, dynamic>>
      _restaurantCollectionReference = db.collection('restaurants');

  Future setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/images/pin.png',
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    Uri googleUri = Uri.parse(googleUrl);
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri);
    } else {
      throw 'Could not open the map.';
    }
  }

  Stream getRestaurantArround(double radius, GeoFirePoint center) {
    return _geo
        .collection(collectionRef: _restaurantCollectionReference)
        .within(
          center: center,
          radius: radius,
          field: restaurantCoordinatesField,
          strictMode: true,
        );
  }

  Marker createMarker(double lat, double lng, MarkerId id, Function onTap,
      Restaurant restaurant) {
    final _marker = Marker(
      onTap: () => onTap(restaurant),
      markerId: id,
      position: LatLng(lat, lng),
      icon: _markerIcon!,
      infoWindow: InfoWindow(
        title: restaurant.name!,
        snippet: 'Hello word',
      ),
    );

    return _marker;
  }

  Map<MarkerId, Marker> getAllMarkers(
      List<Restaurant> documentList, Function onTapMarker) {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    documentList.forEach((Restaurant restaurant) {
      final GeoPoint point = restaurant.position!;
      final id = MarkerId(
        point.latitude.toString() + point.longitude.toString(),
      );
      Marker _marker = createMarker(
        point.latitude,
        point.longitude,
        id,
        onTapMarker,
        restaurant,
      );

      markers[id] = _marker;
    });

    return markers;
  }

  GeoFirePoint convertCoordinatesToGeoFire(LatLng coordinates) {
    GeoFirePoint convertedCoordinates = _geo.point(
        latitude: coordinates.latitude, longitude: coordinates.longitude);

    return convertedCoordinates;
  }

  LatLng convertGeoFireToCoordinates(GeoPoint coordinates) {
    LatLng convertedCoordinates =
        LatLng(coordinates.latitude, coordinates.longitude);
    return convertedCoordinates;
  }

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _userLocation = LatLng(position.latitude, position.longitude);
  }

  Future setMapCurrentLocation(GoogleMapController? mapController) async {
    await getLocation();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            userLocation!.latitude,
            userLocation!.longitude,
          ),
          zoom: 17,
        ),
      ),
    );
  }
}
