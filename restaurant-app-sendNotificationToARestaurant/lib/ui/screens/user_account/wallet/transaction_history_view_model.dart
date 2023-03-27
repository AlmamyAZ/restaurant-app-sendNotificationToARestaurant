import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/transaction_history.dart';
import 'package:stacked/stacked.dart';

class UserTransactionHistoryViewModel extends BaseViewModel {
  List<TransactionHistory> _transactionHistory = [];
  List<TransactionHistory> get transactionHistory => _transactionHistory;
  Future getUserTransactionHistories() async {
    setBusy(true);
    _transactionHistory = await walletAccountService.getUserTransactionHistory(); //TODO: this static userId will be removed if the bug on user profile get fixed
    setBusy(false);
  }
}
