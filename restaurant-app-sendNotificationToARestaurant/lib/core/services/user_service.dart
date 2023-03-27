// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/notification.dart';
import 'package:rxdart/subjects.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/core/models/user.dart' as Model;

@lazySingleton
class UserService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  String? userId = firebaseAuth.currentUser?.uid;

  StreamController userStream = new BehaviorSubject<Model.User>();
  StreamController adressStream = new BehaviorSubject<List<Adress?>>();
  final FirebaseFunctions functions = FirebaseFunctions.instance;

// User Profile

  Stream<Model.User> getUserStream(String uid) {
    _usersCollectionReference.doc(uid).snapshots().listen((eventSnapshot) {
      Map<String, dynamic>? data =
          eventSnapshot.data() as Map<String, dynamic>?;
      Model.User? user;
      if (data != null) {
        user = serializeUser(data, uid);
      } else {
        user = Model.User(
          id: '',
          email: '',
          firstname: '',
          lastname: '',
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
          phoneNumber: '',
          userProfileUrl:
              'https://firebasestorage.googleapis.com/v0/b/eat224-25dca.appspot.com/o/default%2Fdefault-news.jpg?alt=media&token=bcdc3cb1-80be-4fa2-aef1-cc01e1b8560a',
          username: '',
        );
      }
      userStream.add(user);
    });
    return userStream.stream as Stream<Model.User>;
  }

  Model.User serializeUser(Map<String, dynamic> data, String uid) {
    if (data['createdAt'] != null)
      data['createdAt'] = data['createdAt'].toDate();
    if (data['updatedAt'] != null)
      data['updatedAt'] = data['updatedAt'].toDate();
    var user = Model.User.fromJson(data, uid);
    return user;
  }

  Future createUser(Model.User user) async {
    try {
      WriteBatch batch = db.batch();

      Map userData = user.toJson();
      userData['createdAt'] = FieldValue.serverTimestamp();
      userData['updatedAt'] = FieldValue.serverTimestamp();

      batch.set(_usersCollectionReference.doc(user.id), userData);
      batch.set(db.collection('wallet').doc(user.id), {
        'balance': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastRechargeDate': null,
      });

      await batch.commit();
    } catch (e) {
      return e;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();

      Map<String, dynamic>? data = userData.data() as Map<String, dynamic>?;
      if (data == null) return Model.User();
      return serializeUser(data, uid);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future editUser(Model.User user) async {
    try {
      // Edit the firebaseAuth current user
      Map<String, Object?> userData = user.toJson();
      userData['updatedAt'] = FieldValue.serverTimestamp();
      userData.removeWhere((key, value) => value == null);

      await _usersCollectionReference.doc(user.id).update(userData);

      if (user.username != null && user.username!.length != 0)
        firebaseAuth.currentUser!.updateDisplayName(user.username);

      if (user.userProfileUrl != '' && user.userProfileUrl != null)
        firebaseAuth.currentUser!.updatePhotoURL(user.userProfileUrl);
    } catch (e) {
      return e;
    }
  }

  Future addUserProfile(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return Model.User.fromJson(userData.data() as Map<String, dynamic>, uid);
    } catch (e) {
      return e;
    }
  }

// User Adresses

  Stream<List<Adress?>> getUserAdresses() {
    _usersCollectionReference
        .doc(firebaseAuth.currentUser?.uid)
        .collection('adresses')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((event) {
      List<Adress?> adresses = event.docs
          .map((event) {
            Map<String, dynamic> data = event.data();
            data['id'] = event.id;

            return Adress.serializeAdress(data);
          })
          .where((mappedItem) => mappedItem?.latLng != null)
          .toList();

      adressStream.add(adresses);
    });

    return adressStream.stream as Stream<List<Adress?>>;
  }

  Future getUserFirstAdress() async {
    try {
      var adressesDocumentSnapshot = await _usersCollectionReference
          .doc(firebaseAuth.currentUser?.uid)
          .collection('adresses')
          .limit(1)
          .orderBy('createdAt', descending: true)
          .get();

      if (adressesDocumentSnapshot.docs.isNotEmpty) {
        return adressesDocumentSnapshot.docs
            .map((doc) {
              Map<String, dynamic> data = doc.data();
              data['id'] = doc.id;
              return Adress.serializeAdress(doc.data());
            })
            .where((mappedItem) => mappedItem?.latLng != null)
            .toList()
            .first;
      } else {
        print('document not exist');
        return null;
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

  Future createAdress(Adress adress) async {
    try {
      Map<String, dynamic> adressData = convertAdressToJson(adress);
      adressData['updatedAt'] = FieldValue.serverTimestamp();
      adressData['createdAt'] = FieldValue.serverTimestamp();

      await _usersCollectionReference
          .doc(firebaseAuth.currentUser?.uid)
          .collection('adresses')
          .add(adressData);
    } catch (e) {
      return e;
    }
  }

  Future editAdress(Adress adress) async {
    try {
      Map<String, dynamic> adressData = adress.toJson();
      adressData['updatedAt'] = FieldValue.serverTimestamp();

      // remove the unwanted fields by setting them to null
      adressData['id'] = null;
      adressData.removeWhere((key, value) => value == null);

      await _usersCollectionReference
          .doc(firebaseAuth.currentUser?.uid)
          .collection('adresses')
          .doc(adress.id)
          .update(adressData);
    } catch (e) {
      return e;
    }
  }

  Future deleteAdress(String id) async {
    try {
      await _usersCollectionReference
          .doc(firebaseAuth.currentUser?.uid)
          .collection('adresses')
          .doc(id)
          .delete();
    } catch (e) {
      return e;
    }
  }

// User Notifications
  List<OrderNotification> serializeNotification(
    QuerySnapshot dishesDocumentsSnapshot,
  ) {
    return dishesDocumentsSnapshot.docs.map((snapshot) {
      return serializeOrderNotification(
          snapshot.data() as Map<String, dynamic>, snapshot.id);
    }).toList();
  }

  OrderNotification serializeOrderNotification(
      Map<String, dynamic> data, dishId) {
    return OrderNotification.fromJson(data, dishId);
  }

  HttpsCallable triggerCloudFunction(String functionName) {
    return functions.httpsCallable(functionName);
  }

  Future<void> readNotification(String notificationId) async {
    final HttpsCallable markNotificationAsRead =
        triggerCloudFunction('readNotification');
    final data = {'userId': userId, 'notificationId': notificationId};
    await markNotificationAsRead.call(data);
  }

  Future<void> markAllNotificationAsRead(
      List<String?> unReadNotificationIds) async {
    final HttpsCallable markAllNotificationsAsRead =
        triggerCloudFunction('markAllNotificationsAsRead');
    final data = {
      "unReadNotificationIds": unReadNotificationIds,
      "userId": userId
    };
    markAllNotificationsAsRead.call(data);
  }

  //delete all notification
  Future<void> deleteAllNotifications(
      List<OrderNotification> notifications) async {
    final HttpsCallable deleteAllNotifications =
        triggerCloudFunction('deleteAllNotifications');
    final _notificationIds =
        notifications.map((notification) => notification.id);
    final data = {
      'notificationIds': _notificationIds.toList(),
      'userId': userId
    };
    await deleteAllNotifications.call(data);
  }

  Stream orderNotificationStream() {
    CollectionReference _orderNotificationColRef = db
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .collection('notifications');
    return _orderNotificationColRef
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  List getListOfOrderNotifications(colectionsDocumentsSnapshot) {
    return colectionsDocumentsSnapshot.docs.map((snapshot) {
      var data = snapshot.data();
      return OrderNotification.fromJson(data, snapshot.id);
    }).toList();
  }


  Future<Adress> getUserAdressById(String id) async {
    return Adress();
  }

  Future deleteUser() async {
    try {
      await firebaseAuth.currentUser!.delete();
    } catch (e) {
      return e;
    }
  }
}
