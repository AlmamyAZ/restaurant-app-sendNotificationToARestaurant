// Package imports:
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/user.dart';

@injectable
class DashboardViewModel extends ReactiveViewModel {
  User? get currentUser => authenticationService.currentUser;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [authenticationService];

  String? _profilePicture;
  String? get profilePicture => _profilePicture;

  String? _firstname;
  String? get firstname => _firstname;

  String? _lastname;
  String? get lastname => _lastname;

  String? _email;
  String? get email => _email;

  bool get isUserLoggedOut => firebaseAuth.currentUser == null;

  Future fetchUserData() async {
    print('fetchUserData');
    setBusy(true);
    User userData = authenticationService.currentUser!;
    _profilePicture = userData.userProfileUrl;
    _email = userData.email;
    _firstname = userData.firstname;
    _lastname = userData.lastname;
    setBusy(false);
  }

  void logOut() {
    authenticationService.logOut();
  }

  void navigateToLogin() {
    navigationService.navigateTo(Routes.loginView);
  }

  void gotoWalletAccountView() {
    navigationService.navigateTo(Routes.walletAccountView);
  }

  @override
  void dispose() {
    print('view model Dashboard disposed');
    super.dispose();
  }
}
