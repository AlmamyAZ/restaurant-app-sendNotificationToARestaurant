import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/order.dart' as OrderModel;
import 'package:restaurant_app/core/models/payment.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

/// The service responsible for networking requests
//  lazySingleton
class OrderService {
  var uuid = Uuid();

  final db = FirebaseFirestore.instance;

  //stream
  StreamController terminateOrderStreamController =
      new BehaviorSubject<List<OrderModel.Order>>();
  StreamController incomingOrderStreamController =
      new BehaviorSubject<List<OrderModel.Order>>();

  CollectionReference _collectionCollectionReference =
      FirebaseFirestore.instance.collection('orders');

  Future addUserOrder(
    Map<String, dynamic> orderData,
    String id,
    Map<String, dynamic> paymentData,
  ) async {
    final batch = db.batch();
    final orderRef = _collectionCollectionReference.doc(id);
    final paymentRef = db.collection('payments').doc(id);

    batch.set(orderRef, orderData);
    batch.set(paymentRef, paymentData);
    await batch.commit();
  }

  Future cancelOrder(String orderId, String userId, double amount,
      PaymentMethod paymentMethod) async {
    try {
      WriteBatch batch = db.batch();

      String walletTransactionId = Uuid().v4();

      DocumentReference walletTransactionRef = db
          .collection('wallet')
          .doc(userId)
          .collection('walletTransaction')
          .doc(walletTransactionId);

      batch.update(_collectionCollectionReference.doc(orderId), {
        'completed': true,
        'status': OrderModel.OrderStatus.canceledByUser.index,
      });

      if (paymentMethod != PaymentMethod.cash) {
        batch.update(db.collection("wallet").doc(userId),
            {"balance": FieldValue.increment(amount)});

        batch.set(walletTransactionRef, {
          "amount": amount,
          "createdAt": FieldValue.serverTimestamp(),
          'isEntry': true,
          'name': 'Remboursement commande ',
          'paymentMethod': PaymentMethod.system.index,
          'reference': orderId,
        });

        batch.set(db.collection('transactions').doc(walletTransactionId), {
          "amount": amount,
          "createdAt": FieldValue.serverTimestamp(),
          'isEntry': false,
          'name': 'Remboursement commande ',
          'paymentMethod': PaymentMethod.system.index,
          'reference': orderId,
        });
      }

      await batch.commit();
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getAllOrders() async {
    try {
      var colectionsDocumentsSnapshot = await _collectionCollectionReference
          .where('userId', isEqualTo: firebaseAuth.currentUser?.uid)
          .get();
      if (colectionsDocumentsSnapshot.docs.isNotEmpty) {
        return colectionsDocumentsSnapshot.docs
            .map((snapshot) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;

              return serializeOrder(data, snapshot.id);
            })
            .where((mappedItem) => mappedItem.id != null)
            .toList();
      } else {
        return List<OrderModel.Order>.from([]);
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

  Stream<List<OrderModel.Order>> getTerminatedOrders() {
    _collectionCollectionReference
        .where('userId', isEqualTo: firebaseAuth.currentUser?.uid)
        .where('completed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      List<OrderModel.Order> orders = event.docs
          .map((snapshot) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            return serializeOrder(data, snapshot.id);
          })
          .where((mappedItem) => mappedItem.id != null)
          .toList();

      terminateOrderStreamController.add(orders);
    });

    return terminateOrderStreamController.stream
        as Stream<List<OrderModel.Order>>;
  }

  Stream<List<OrderModel.Order>> getIncomingOrders() {
    _collectionCollectionReference
        .where('userId', isEqualTo: firebaseAuth.currentUser?.uid)
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      List<OrderModel.Order> orders = event.docs
          .map((snapshot) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            return serializeOrder(data, snapshot.id);
          })
          .where((mappedItem) => mappedItem.id != null)
          .toList();

      incomingOrderStreamController.add(orders);
    });

    return incomingOrderStreamController.stream
        as Stream<List<OrderModel.Order>>;
  }

  Stream getOrder(String? orderId) {
    if (orderId == null) {
      return Stream.empty();
    }
    return _collectionCollectionReference.doc(orderId).snapshots();
  }

  OrderModel.Order serializeOrder(Map<String, dynamic> data, String id) {
    data['createdAt'] = data['createdAt']?.toDate();
    data['deliveryLocation'] = Adress.serializeAdress(data['deliveryLocation']);
    data['pickupLocation'] = Adress.serializeAdress(data['pickupLocation']);
    data['status'] = OrderModel.OrderStatus.values[data['status']];
    data['orderTime'] = OrderTime.values[data['orderTime']];
    data['paymentMethodIndex'] =
        PaymentMethod.values[data['paymentMethodIndex']];
    var order = OrderModel.Order.fromJson(data, id);
    return order;
  }

  void dispose() {
    terminateOrderStreamController.close();
    incomingOrderStreamController.close();
  }
}
