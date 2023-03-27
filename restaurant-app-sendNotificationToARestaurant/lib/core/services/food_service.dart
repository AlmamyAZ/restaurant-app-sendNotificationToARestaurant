// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import '../../core/models/dish.dart';

/// The service responsible for networking requests
@lazySingleton
class FoodService {
  final CollectionReference _foodCollectionReference =
      FirebaseFirestore.instance.collection('dishs');

  StreamController likeDishControler =
      new BehaviorSubject<Map<String, dynamic>?>();

  DocumentReference getUserDishLikeDocumentRef(String? dishId) {
    String? userId = firebaseAuth.currentUser?.uid;

    return db
        .collection('users')
        .doc(userId)
        .collection('dishLikes')
        .doc(dishId);
  }

  Stream<Map<String, dynamic>?> listenToDishLikestream(String? dishId) {
    getUserDishLikeDocumentRef(dishId).snapshots().listen((eventSnapshot) {
      Map<String, dynamic>? event =
          eventSnapshot.data() as Map<String, dynamic>?;
      likeDishControler.add(event);
    });

    return likeDishControler.stream as Stream<Map<String, dynamic>?>;
  }

  Future likeDish(String dishId, bool state) async {
    int incrementValue = state ? -1 : 1;

    WriteBatch batch = db.batch();

    batch.set(getUserDishLikeDocumentRef(dishId), {
      'state': !state,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(db.collection('dishs').doc(dishId), {
      'likerCount': FieldValue.increment(incrementValue),
    });

    //mettre a jour les statistque des j'aime au niveau des revue

    try {
      batch.commit();
    } catch (e) {}
  }

  Stream dishsStream() {
    return _foodCollectionReference.snapshots();
  }

  Future getDishes() async {
    try {
      var dishsDocumentsSnapshot =
          await _foodCollectionReference.limit(4).get();
      if (dishsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeDishs(dishsDocumentsSnapshot);
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

  Future getAllDishes() async {
    try {
      var dishsDocumentsSnapshot = await _foodCollectionReference.get();
      if (dishsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeDishs(dishsDocumentsSnapshot);
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

  Future getDishById(String id) async {
    final DocumentReference _foodDocumentReference =
        FirebaseFirestore.instance.collection('dishs').doc(id);
    try {
      var dishesDocumentsSnapshot = await _foodDocumentReference.get();
      if (dishesDocumentsSnapshot.exists) {
        Map<String, dynamic> dish =
            dishesDocumentsSnapshot.data() as Map<String, dynamic>;
        return serializeDish(dish, dishesDocumentsSnapshot.id);
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      return e.toString();
    }
  }

  List<Dish> serializeDishs(
    QuerySnapshot dishesDocumentsSnapshot,
  ) {
    return dishesDocumentsSnapshot.docs
        .map((snapshot) {
          return serializeDish(
              snapshot.data() as Map<String, dynamic>, snapshot.id);
        })
        .where((mappedItem) => mappedItem.name != null)
        .toList();
  }

  Dish serializeDish(Map<String, dynamic> data, dishId) {
    data['createdAt'] = data['createdAt'].toDate();
    return Dish.fromJson(data, dishId);
  }
}
