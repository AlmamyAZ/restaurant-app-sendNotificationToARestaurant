// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/ui/widgets/adress/adresses_list_choice.dart';
import 'package:restaurant_app/ui/widgets/adress/district_list_choice.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_checkout_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@injectable
class AdressesViewModel extends StreamViewModel<List<Adress?>> {
  bool _editMode = false;
  bool get editMode => _editMode;

  RestaurantCartCheckoutViewModel? checkoutModel;

  String? _adressId;

  final TextEditingController districtController = TextEditingController();
  final TextEditingController zoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  LatLng _initialPosition = const LatLng(9.5501587, -13.6565422);
  LatLng get initialPosition => _initialPosition;

  Adress? _selectedAdress;
  Adress? get selectedAdress => _selectedAdress;

  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> get markers => _markers;

  List<String> get districts =>
      ['Dixinn', 'Kaloum', 'Matam', 'Matoto', 'Ratoma', 'Coyah'];

  List<Adress?>? get adresses => data;

  @override
  Stream<List<Adress?>> get stream => userService.getUserAdresses();

  Future fetchFirstAdress() async {
    setBusy(true);
    _selectedAdress = await userService.getUserFirstAdress();
    setBusy(false);
  }

  Future fetchAdressById(String id) async {
    setBusy(true);
    Adress adress = await userService.getUserAdressById(id);
    districtController.text = adress.district!;
    zoneController.text = adress.zone!;
    nameController.text = adress.name!;
    descriptionController.text = adress.description!;
    phoneController.text = adress.contactNumber!;
    setBusy(false);
  }

  void getLocation() {
    mapService.setMapCurrentLocation(mapController!);
  }

  Future activateEditMode() async {
    setBusy(true);
    _editMode = true;
    setBusy(false);
  }

  Future createAdress() async {
    setBusy(true);
    await userService.createAdress(
      Adress(
        name: nameController.text,
        district: districtController.text,
        zone: zoneController.text,
        description: descriptionController.text,
        plusCode: '',
        latLng: _initialPosition,
        contactNumber: phoneController.text,
        isDefault: false,
        createdAt: null,
        updatedAt: null,
      ),
    );
    _editMode = false;
    setBusy(false);

    navigationService.back(result: {
      'active': true,
      'message': 'Votre adresse a été créée avec succees'
    });
  }

  void showDistricts(ctx, AdressesViewModel model) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      context: ctx,
      builder: (_) {
        return DistrictListChoices(
          model: model,
        );
      },
    );
  }

  Future editAdress() async {
    setBusy(true);
    await userService.editAdress(
      Adress(
        id: _adressId,
        name: nameController.text,
        district: districtController.text,
        zone: zoneController.text,
        description: descriptionController.text,
        plusCode: '',
        contactNumber: phoneController.text,
        isDefault: false,
        updatedAt: null,
      ),
    );
    _editMode = false;
    setBusy(false);
    snackbarService.showSnackbar(
      message: 'Vos modifications on été sauvegardé avec succees',
    );
  }

  Future deleteAdressById() async {
    DialogResponse? response = await dialogService.showDialog(
        title: 'Supression d\'adresse',
        description:
            'Cette adresse seras suprime de maniere definitive. Voulez vous continuer ?',
        cancelTitle: 'Annuler',
        cancelTitleColor: Colors.red,
        buttonTitle: 'Oui');

    if (!response!.confirmed) return;

    setBusy(true);
    await userService.deleteAdress(_adressId!);
    setBusy(false);
    navigationService.back(result: {
      'active': true,
      'message': 'Votre adresse a été suprimée avec succees'
    });
  }

  void onBackAdressMessage(String message) {
    snackbarService.showSnackbar(
      message: message,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future initialiseMapForm(
      {Map? initialisationData, RestaurantCartCheckoutViewModel? model}) async {
    setBusy(true);
    if (model != null) checkoutModel = model;

    Adress? adress = initialisationData!['adress'];

    if (initialisationData['reload'] != null && initialisationData['reload']) {
      await Future.delayed(Duration(milliseconds: 500));
    }

    if (adress != null && !initialisationData['newAdress']) {
      _adressId = adress.id;
      districtController.text = adress.district!;
      zoneController.text = adress.zone!;
      nameController.text = adress.name!;
      descriptionController.text = adress.description!;
      phoneController.text = adress.contactNumber!;
    }

    _initialPosition = initialisationData['coordinates'] ?? _initialPosition;

    if (_markers.isNotEmpty) {
      _markers = HashSet<Marker>();
    }

    _markers.add(
      Marker(markerId: MarkerId('cameraLocation'), position: _initialPosition),
    );

    _editMode = initialisationData['newAdress'];

    setBusy(false);
  }

  void initialiseMap() {
    _markers.add(
      Marker(markerId: MarkerId('cameraLocation'), position: _initialPosition),
    );
    notifyListeners();
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

  void showAdresses(ctx, AdressesViewModel model) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      context: ctx,
      builder: (_) {
        return AdressesListChoices(model: model);
      },
    );
  }

  void selectNewAdress(Adress adress) {
    setBusy(true);
    checkoutModel?.setOrderAdressToCheckout(adress);

    _selectedAdress = adress;
    notifyListeners();
    setBusy(false);
  }

  void selectDistrict(String district) {
    districtController.text = district;
    notifyListeners();
    navigationService.back();
  }

  Future addNewAdress() async {
    var backResult =
        await navigationService.navigateTo(Routes.adressMapSelectionScreen);

    if (backResult['active']) {
      onBackAdressMessage(backResult['message']);
    }
  }

  @override
  void dispose() {
    print('view model Account disposed');
    super.dispose();
  }
}
