// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/collection.dart';
import 'package:restaurant_app/core/services/collection_service.dart';
import 'package:restaurant_app/ui/widgets/collection/views/add_new_collection.dart';

@singleton // Add decoration
class CollectionModel extends StreamViewModel {
  List<Collection> _userCollections = [];
  List<Collection> get userCollections => _userCollections;

  final collectionName = TextEditingController();

  bool isThisRestaurantInside(List<String> restaurantsId, String restaurantId) {
    return restaurantsId.contains(restaurantId);
  }

  Future addOrRemoveRestaurandsToCollection(
      String collectionId, String restaurantId, bool isAdding) async {
    setBusy(true);
    isAdding
        ? await collectionService.addRestaurantToCollection(
            collectionId, restaurantId)
        : await collectionService.removeRestaurantToCollection(
            collectionId, restaurantId);
    setBusy(false);
  }

  Future showAddNewCollectionModal(ctx) async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      context: ctx,
      builder: (_) {
        return AddNewCollection();
      },
    );

    collectionName.text = '';
  }

  @override
  Stream get stream => locator<CollectionService>().collectionStream();

  @override
  void onData(data) {
    List collection = collectionService.getListOfCollections(data);
    print('collection:: ${collection[0].toJson()} ');
    _userCollections = List<Collection>.from(collection);
  }

  void popScreens(isPop) {
    if (isPop) {
      navigationService.back();
    }
  }

  Future addUserCollection(isPop) async {
    setBusy(true);
    Collection newCollection = Collection(
      color: generateColorForCollection(),
      title: collectionName.text,
      isDefault: false,
      restaurantIds: [],
    );

    await collectionService.addUserCollections(newCollection);
    popScreens(isPop);
    snackbarService.showSnackbar(
        message: 'ajouter avec succes', title: 'Collection');

    setBusy(false);
  }

  Future deleteUserCollection(String collectionId, isPop) async {
    setBusy(true);
    await collectionService.deleteUserCollection(collectionId);
    setBusy(false);
    popScreens(isPop);
    snackbarService.showSnackbar(
        message: 'Collection supprimée avec succes', title: 'Collection');
  }

  @override
  void dispose() {
    print('collections disposed!!');
    super.dispose();
  }
}
