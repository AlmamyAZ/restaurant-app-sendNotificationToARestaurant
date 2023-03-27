// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirestoreService {
  Future deleteSubCollection(
    CollectionReference subCollectionRef, {
    bool isBatch = false,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return subCollectionRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      if (isBatch) return batch;

      return batch.commit();
    });
  }

  Future deleteSubCollectionTransaction(
    CollectionReference subCollectionRef, {
    Transaction? transaction,
  }) async {
    return subCollectionRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        transaction!.delete(doc.reference);
      });
    });
  }
}
