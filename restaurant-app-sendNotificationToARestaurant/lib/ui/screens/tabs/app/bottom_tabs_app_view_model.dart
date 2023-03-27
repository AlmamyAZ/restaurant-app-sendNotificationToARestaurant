// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

class BottomTabsAppViewModel extends BaseViewModel {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  bool _reverse = false;
  bool get reverse => _reverse;

  void setTabIndex(int value) async {
    if (authenticationService.currentUser == null) {
      if (value == 2) {
        await navigationService.navigateTo(Routes.loginView);
        if (firebaseAuth.currentUser == null) return;
      }
    }
    if (value < _currentTabIndex) {
      _reverse = true;
    }

    _currentTabIndex = value;
    notifyListeners();
  }
}
