import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/wallet_account.dart';
import 'package:stacked/stacked.dart';

class WalletAccountViewModel extends StreamViewModel {
  WalletAccount? _walletAccount;
  WalletAccount? get walletAccount => _walletAccount;

  @override
  void onData(data) {
    _walletAccount = data;
    notifyListeners();
  }

  void gotoRechargeAccountView() {
    navigationService.navigateTo(Routes.rechargeAccountView);
  }

  void gotoUserTransactionHistoryView() {
    navigationService.navigateTo(Routes.userTransactionHistoryView);
  }

  @override
  Stream get stream => walletAccountService.getUserWalletStream();
}
