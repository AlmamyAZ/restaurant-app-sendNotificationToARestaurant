// Add decoration
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:restaurant_app/core/services/order_service.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/orders_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderDetailsViewModel extends StreamViewModel {
  String? orderId;

  OrderDetailsViewModel();

  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> get markers => _markers;

  Order? _selectedOrder;
  Order? get selectedOrder => _selectedOrder;

  OrdersViewModel _ordersViewModel = locator<OrdersViewModel>();

  @override
  Stream get stream => locator<OrderService>().getOrder(orderId);

  void initialiseViewModel(String orderId) {
    setBusy(true);
    this.orderId = orderId;
    notifySourceChanged();
    initialise();
    setBusy(false);
  }

  Order serializeOrder(snapshot) {
    var data = snapshot.data();
    return orderService.serializeOrder(data, snapshot.id);
  }

  @override
  void onData(data) {
    _selectedOrder = serializeOrder(data);
    _ordersViewModel.selectedOrder = _selectedOrder;
    notifyListeners();
  }

  Future cancelOrder() async {
    setBusyForObject(selectedOrder, true);
    DialogResponse? response = await dialogService.showDialog(
      title: 'Annulation de la commande',
      description:
          "l'annulation de la commande de maniere definitive. Voulez vous continuer ?",
      cancelTitle: 'Annuler',
      cancelTitleColor: Colors.red,
      buttonTitle: 'Oui',
    );
    if (!response!.confirmed) {
      setBusyForObject(selectedOrder, false);
      return;
    }
    await orderService.cancelOrder(selectedOrder!.id!, selectedOrder!.userId!,
        selectedOrder!.total!, selectedOrder!.paymentMethod!);
    setBusyForObject(selectedOrder, false);
  }

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  LatLng _initialPosition = const LatLng(9.5501587, -13.6565422);
  LatLng get initialPosition => _initialPosition;

  LatLng _pickupLocation = const LatLng(9.5501587, -13.6565422);
  LatLng get pickupLocation => _pickupLocation;

  LatLng _deliveryLocation = const LatLng(9.5501587, -13.6565422);
  LatLng get deliveryLocation => _deliveryLocation;

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    initialiseMap();
    await updateCameraLocation(
        pickupLocation, deliveryLocation, mapController!);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  void navigateToOrderDetails() {
    navigationService.navigateTo(Routes.orderDetailsScreen,
        arguments: selectedOrder);
  }

  String getOrderEstimateDelivery() {
    switch (selectedOrder!.status) {
      case OrderStatus.waitingRestaurantConfirmation:
        return 'Votre commande est en attente de confirmation par ${selectedOrder!.restaurantName} !';
      case OrderStatus.processingByRestaurant:
        return 'Votre commande est en cours de preparation par le restaurant !';
      case OrderStatus.delivering:
        return 'Un de nos coursier est actuellement en route pour vous livrer !';
      case OrderStatus.waitingForPickup:
        return 'Votre commande est prete et n\attend que vous pour etre degusté !';
      case OrderStatus.completed:
        return '';
      case OrderStatus.rejectedByRestaurant:
        return '';
      case OrderStatus.canceledByUser:
        return '';
      default:
        return '';
    }
  }

  void initialiseMap() async {
    _pickupLocation = selectedOrder?.pickupLocation?.latLng ?? _initialPosition;
    _deliveryLocation =
        selectedOrder!.deliveryLocation?.latLng ?? initialPosition;

    if (_markers.isNotEmpty) {
      _markers = HashSet<Marker>();
    }

    BitmapDescriptor markerHome = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/images/pinHome.png',
    );

    BitmapDescriptor markerRestaurant = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/images/pinRestaurant.png',
    );

    _markers.addAll([
      Marker(
          markerId: MarkerId('restaurant'),
          position: pickupLocation,
          icon: markerRestaurant),
      Marker(
          markerId: MarkerId('home'),
          position: deliveryLocation,
          icon: markerHome),
    ]);
    notifyListeners();
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    // LatLngBounds bounds;

    // if (source.latitude > destination.latitude &&
    //     source.longitude > destination.longitude) {
    //   bounds = LatLngBounds(southwest: destination, northeast: source);
    // } else if (source.longitude > destination.longitude) {
    //   bounds = LatLngBounds(
    //       southwest: LatLng(source.latitude, destination.longitude),
    //       northeast: LatLng(destination.latitude, source.longitude));
    // } else if (source.latitude > destination.latitude) {
    //   bounds = LatLngBounds(
    //       southwest: LatLng(destination.latitude, source.longitude),
    //       northeast: LatLng(source.latitude, destination.longitude));
    // } else {
    //   bounds = LatLngBounds(southwest: source, northeast: destination);
    // }

    // CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70); // TODO: a revoir...

    // return checkCameraLocation(cameraUpdate, mapController);
  }

  @override
  void dispose() {
    print('collections disposed!!');
    super.dispose();
  }
}
