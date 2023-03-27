// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/collection.dart';

@lazySingleton
class CollectionService {
  Future addUserCollections(
    Collection collectionData,
  ) async {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    Map collection = collectionData.toJson();
    collection['createdAt'] = FieldValue.serverTimestamp();
    _collectionCollectionReference.add(collection);
  }

  Future addRestaurantToCollection(collectionId, restaurantId) async {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    WriteBatch batch = db.batch();

    batch.update(_collectionCollectionReference.doc(collectionId), {
      'restaurantIds': FieldValue.arrayUnion([restaurantId]),
      'nbPlaces': FieldValue.increment(1),
    });

    batch.commit();
  }

  Future removeRestaurantToCollection(collectionId, restaurantId) async {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    WriteBatch batch = db.batch();

    batch.update(_collectionCollectionReference.doc(collectionId), {
      'restaurantIds': FieldValue.arrayRemove([restaurantId]),
      'nbPlaces': FieldValue.increment(-1),
    });

    batch.commit();
  }

  Future<bool> isRestaurantCollectionned(String restaurantId) async {
    if (firebaseAuth.currentUser == null) return false;
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    var colectionsDocumentsSnapshot = await _collectionCollectionReference
        .where('restaurantIds', arrayContains: restaurantId)
        .limit(1)
        .get();

    return colectionsDocumentsSnapshot.size == 1;
  }

  Stream restaurantCollectionned(String restaurantId) {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    return _collectionCollectionReference
        .where('restaurantIds', arrayContains: restaurantId)
        .limit(1)
        .snapshots();
  }

  Future deleteUserCollection(collectionId) async {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    _collectionCollectionReference.doc(collectionId).delete();
  }

  Stream collectionStream() {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');
    return _collectionCollectionReference
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  List getListOfCollections(colectionsDocumentsSnapshot) {
    // if (colectionsDocumentsSnapshot.docs.isNotEmpty) {
    return colectionsDocumentsSnapshot.docs
        .map((snapshot) {
          var data = snapshot.data();

          return Collection.fromJson(data, snapshot.id);
        })
        .where((mappedItem) => mappedItem.title != null)
        .toList();
  }

  Future getUserCollections() async {
    CollectionReference _collectionCollectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid) // inject the userId there
            .collection('collections');

    try {
      var colectionsDocumentsSnapshot =
          await _collectionCollectionReference.get();
      if (colectionsDocumentsSnapshot.docs.isNotEmpty) {
        return colectionsDocumentsSnapshot.docs
            .map((snapshot) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;

              return Collection.fromJson(data, snapshot.id);
            })
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      } else {
        return List<Collection>.from([]);
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

  Future createDefaultCollection() async {
    Collection newCollection = Collection(
      color: 'FF808080',
      title: 'Par défaut',
      isDefault: true,
      nbPlaces: 0,
      restaurantIds: [],
    );

    await addUserCollections(newCollection);
  }
}
