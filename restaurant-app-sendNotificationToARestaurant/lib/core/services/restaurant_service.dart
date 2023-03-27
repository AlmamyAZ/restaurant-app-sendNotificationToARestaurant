// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/image.dart';
import 'package:restaurant_app/core/models/menu.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/core/services/upload_service.dart';
import 'package:logger/logger.dart';

/// The service responsible for networking requests
@lazySingleton
class RestaurantService {
  var logger = Logger();
  final CollectionReference _restaurantCollectionReference =
      FirebaseFirestore.instance.collection('restaurants');

  Query<Object?> get getActiveRestaurantQuery =>
      _restaurantCollectionReference.where('isActive', isEqualTo: true);

  final CollectionReference _menuCollectionReference =
      FirebaseFirestore.instance.collection('menus');

  UploadService _uploadService = locator<UploadService>();

  bool _restaurantMenuInit = false;
  bool get restaurantmenuInit => _restaurantMenuInit;

  bool _restaurantPhotosInit = false;
  bool get restaurantPhotosInit => _restaurantPhotosInit;

  bool _restaurantReviewsInit = false;
  bool get restaurantReviewsInit => _restaurantReviewsInit;

  String? _currentRestaurantId;
  String? get currentRestaurantId => _currentRestaurantId;

  String? _currentRestaurantPhoneNumber;
  String? get currentRestaurantPhoneNumber => _currentRestaurantPhoneNumber;

  String? _currentRestaurantName;
  String? get currentRestaurantName => _currentRestaurantName;

  List<Map<String, dynamic>>? _currentRestaurantOpenHours;
  List<Map<String, dynamic>>? get currentRestaurantOpenHours =>
      _currentRestaurantOpenHours;

  void setRestaurantmenuInit(bool state) {
    _restaurantMenuInit = state;
  }

  void setRestaurantPhotosInit(bool state) {
    _restaurantPhotosInit = state;
  }

  void setRestaurantReviewsInit(bool state) {
    _restaurantReviewsInit = state;
  }

  void setCurrentRestaurantId(String? id) {
    _currentRestaurantId = id;
  }

  void setCurrentRestaurantName(String? name) {
    _currentRestaurantName = name;
  }

  void setCurrentRestaurantOpenHours(List<Map<String, dynamic>>? openHours) {
    _currentRestaurantOpenHours = openHours;
  }

  void setCurrentRestaurantPhoneNumber(String? phoneNumber) {
    _currentRestaurantPhoneNumber = phoneNumber;
  }

  Future getDishRestaurants(idDish) async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery.get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getTopRestaurants() async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery
          .orderBy('rating', descending: true)
          .get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        // return "document not exist";
        return List<Restaurant>.from([]);
      }
    } catch (e) {
      logger.w('message: $e');
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print('error: ${e.toString()}');

      return e.toString();
    }
  }

  Future getAllRestaurants() async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery.get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future<List<Restaurant>?> getRestaurantsForBundle(
      String establishmentId) async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery
          .where('establishmentIds', arrayContains: establishmentId)
          .get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        print('exist');
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        print('not exist');
        return List<Restaurant>.from([]);
      }
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future getRestaurantsForCategory(String categoryId) async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery
          .where('categoriesIds', arrayContains: categoryId)
          .get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        return List<Restaurant>.from([]);
      }
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future getRestaurantsForCollection(restaurantIds) async {
    List<Restaurant> restaurants = [];
    try {
      for (var restaurantId in restaurantIds) {
        var restaurantsDocumentsSnapshot =
            await _restaurantCollectionReference.doc(restaurantId).get();
        if (restaurantsDocumentsSnapshot.exists) {
          restaurants.add(
            serializeRestaurant(
              restaurantsDocumentsSnapshot.data() as Map<String, dynamic>,
              restaurantsDocumentsSnapshot.id,
            ),
          );
        } else {
          // return "document not exist";
          return List<Restaurant>.from([]);
        }
      }
      return restaurants;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future getRelatedRestaurants(List<String> categoriesId) async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery
          .where('categoriesId', arrayContainsAny: categoriesId)
          .get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        // return "document not exist";
        return List<Restaurant>.from([]);
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getSponsoredRestaurants() async {
    try {
      var restaurantsDocumentsSnapshot = await getActiveRestaurantQuery
          .where('isSponsorised', isEqualTo: true)
          .get();
      if (restaurantsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeRestaurants(restaurantsDocumentsSnapshot);
      } else {
        // return "document not exist";
        return List<Restaurant>.from([]);
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getRestaurantById(String id) async {
    try {
      var restaurantDocumentSnapshot =
          await _restaurantCollectionReference.doc(id).get();
      if (restaurantDocumentSnapshot.exists) {
        return serializeRestaurant(
          restaurantDocumentSnapshot.data() as Map<String, dynamic>,
          restaurantDocumentSnapshot.id,
        );
      } else {
        return Restaurant();
        // return "document not exist";
      }
    } catch (e) {
      print('e $e');
      throw e;
    }
  }

  List<Restaurant> serializeRestaurants(
      QuerySnapshot restaurantsDocumentsSnapshot) {
    return restaurantsDocumentsSnapshot.docs
        .map((snapshot) {
          return serializeRestaurant(
              snapshot.data() as Map<String, dynamic>, snapshot.id);
        })
        .where((mappedItem) => mappedItem.name != null)
        .toList();
  }

  Restaurant serializeRestaurant(Map<String, dynamic> data, restaurantId) {
    try {
      data['createdAt'] = data['createdAt'].toDate();
      data['installation'] = getInstallation(data['installations']);
      data['dishDay'] = listMapToListString(data['dishDay']);

      String zone = data['adress']['zone'];
      String quartier = data['adress']['quartier'];
      String description = data['adress']['description'];

      data['fullAdress'] = '$zone, $quartier, $description';
      data['position'] = data['adress'] != null
          ? data['adress']['position']['geopoint']
          : null;

      return Restaurant.fromJson(data, restaurantId);
    } catch (e) {
      return Restaurant();
    }
  }

  String getInstallation(List<dynamic> data) {
    return listMapToListString(data).join(' ');
  }

  List<String> listMapToListString(List<dynamic> data,
      {String property = 'name'}) {
    return data.map((element) => element[property] as String).toList();
  }

  Future getMenuByRestaurantId(String id) async {
    try {
      var menuDocumentSnapshot = await _menuCollectionReference.doc(id).get();

      if (menuDocumentSnapshot.exists) {
        Map<String, dynamic> data =
            menuDocumentSnapshot.data() as Map<String, dynamic>;
        data['createdAt'] = data['createdAt'].toDate();
        data['menuSection'] = await getGeneratedSectionByMenuId(id, data['id']);
        return Menu.fromJson(data, menuDocumentSnapshot.id);
      } else {
        // return "document not exist";
        return null;
      }
    } catch (e) {
      print('error : $e');
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getGeneratedSectionByMenuId(restuarntId, menuId) async {
    var documeentSnapshot = await _menuCollectionReference
        .doc(restuarntId)
        .collection('generatedSection')
        .where('menusIds', arrayContains: menuId)
        .get();

    List<Map<String, dynamic>> menuSection = [];

    documeentSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      menuSection.add(data);
    });

    return menuSection;
  }

  Future setImageComment(
      {String? restaurantId, Map<String, dynamic>? data}) async {
    try {
      return await _restaurantCollectionReference
          .doc(restaurantId)
          .collection('images')
          .add(data!);
    } catch (e) {}
  }

  Future<List<Image>> getPhotosByRestaurantId(String id, String? filter) async {
    try {
      CollectionReference photosSubcollectionReference =
          _restaurantCollectionReference.doc(id).collection('images');

      var photosDocumentsSnapshot;

      if (filter != null) {
        photosDocumentsSnapshot = await photosSubcollectionReference
            .where('subject', isEqualTo: filter)
            .orderBy('createdAt', descending: true)
            .get();
      } else {
        photosDocumentsSnapshot = await photosSubcollectionReference
            .orderBy('createdAt', descending: true)
            .get();
      }
      if (photosDocumentsSnapshot.docs.isNotEmpty) {
        return List<Image>.from(photosDocumentsSnapshot.docs.map((snapshot) {
          var data = snapshot.data();
          Image img = Image.serializeImage(data, snapshot.id);
          return img;
        }).toList());
      } else {
        print('hello test2');
        // return "document not exist";
        return [] as List<Image>;
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return List<Image>.from([]);
      }
      print(e.toString());
      return List<Image>.from([]);
    }
  }

  Future deletePhotoById(
      String restaurantId, String imageId, String imageLink) async {
    DocumentReference photosDocumentReference = _restaurantCollectionReference
        .doc(restaurantId)
        .collection('images')
        .doc(imageId);

    await photosDocumentReference.delete();
    await _uploadService.deleteImage(imageLink);
  }

  Future getUserPhotos(String userId) async {
    try {
      Query query = FirebaseFirestore.instance
          .collectionGroup('images')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      QuerySnapshot photosDocumentsSnapshot = await query.get();

      if (photosDocumentsSnapshot.docs.isNotEmpty) {
        return List<Image>.from(photosDocumentsSnapshot.docs.map((snapshot) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return Image.serializeImage(data, snapshot.id);
        }).toList());
      } else {
        return List<Image>.from([]);
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }
}
