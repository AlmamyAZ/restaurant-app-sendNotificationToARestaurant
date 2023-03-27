import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/transaction_history.dart';
import 'package:restaurant_app/core/models/wallet_account.dart';
import 'package:uuid/uuid.dart';

class WalletAccountService {
  final walletCollectionReference = db.collection('wallet');

  Future getUserTransactionHistory() async {
    String userId = authenticationService.currentUser!.id!;
    CollectionReference transactionRef =
        db.collection('wallet').doc(userId).collection('walletTransaction');
    QuerySnapshot documentSnapshots = await transactionRef.get();
    return serializeTransactions(documentSnapshots);
  }

  Future getUserWallet() async {
    String? userId = authenticationService.currentUser!.id;
    DocumentSnapshot userWalletDocSnapshot =
        await walletCollectionReference.doc(userId).get();
    if (userWalletDocSnapshot.exists) {
      return serializeWalletAccount(
        userWalletDocSnapshot.data(),
        userWalletDocSnapshot.id,
      );
    }
  }

  Stream getUserWalletStream() {
    String? userId = authenticationService.currentUser!.id;
    return walletCollectionReference
        .doc(userId)
        .snapshots()
        .map((event) => serializeWalletAccount(event.data(), event.id));
  }

  Future debitWallet(double amount, walledId) async {
    WriteBatch batch = db.batch();
    String walletTransactionId = Uuid().v4();
    String? userId = authenticationService.currentUser!.id;

    DocumentReference walletTransactionRef = walletCollectionReference
        .doc(userId)
        .collection('walletTransaction')
        .doc(walletTransactionId);

    batch.update(walletCollectionReference.doc(walledId), {
      "balance": FieldValue.increment(-amount),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    batch.set(walletTransactionRef, {
      "amount": amount,
      "createdAt": FieldValue.serverTimestamp(),
      'isEntry': false,
      'name': 'Paiement de la commande',
    });

    await batch.commit(); 
  }

  Future rechargeWallet(
      double amount, paymentMethodIndex, token, payToken) async {
    WriteBatch batch = db.batch();

    String walletTransactionId = Uuid().v4();

    String? userId = authenticationService.currentUser!.id;

    DocumentReference walletTransactionRef = walletCollectionReference
        .doc(userId)
        .collection('walletTransaction')
        .doc(walletTransactionId);

    batch.update(walletCollectionReference.doc(userId), {
      "balance": FieldValue.increment(amount),
      "updatedAt": FieldValue.serverTimestamp(),
      "lastRechargeDate": FieldValue.serverTimestamp(),
    });

    batch.set(walletTransactionRef, {
      "amount": amount,
      "createdAt": FieldValue.serverTimestamp(),
      'isEntry': true,
      'name': 'Recharge du compte',
      'paymentMethod': paymentMethodIndex,
      'reference': payToken,
      'tokenOM': token,
    });

    await batch.commit();
  }

  Future payWithWallet(double amount) async {
    WalletAccount wallet = await getUserWallet();
    if (wallet.balance < amount) throw Exception("Solde insuffisant");
    debitWallet(amount, wallet.id);
  }

  List<TransactionHistory> serializeTransactions(QuerySnapshot data) {
    return data.docs.map((onsnap) {
      return serializeTransaction(onsnap.data(), onsnap.id);
    }).toList();
  }

  TransactionHistory serializeTransaction(dynamic data, String id) {
    data['createdAt'] = data['createdAt'].toDate();
    return TransactionHistory.fromJson(data, id);
  }

  WalletAccount serializeWalletAccount(dynamic data, String id) {
    data['lastRechargeDate'] = data['lastRechargeDate']?.toDate();
    return WalletAccount.fromJson(data, id);
  }
}
