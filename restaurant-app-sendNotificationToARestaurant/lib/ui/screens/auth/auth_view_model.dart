// Package imports:
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/core/services/firebase_service/firebase_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:

import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';

@injectable
class AuthViewModel extends BaseViewModel {
  bool _isAppleSignInAvailable = false;
  bool get isAppleSignInAvailable => _isAppleSignInAvailable;

  bool _socialProfileLoading = false;
  bool get socialProfileLoading => _socialProfileLoading;

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      setBusy(true);
      var result = await authenticationService.loginWithEmail(
        email: email,
        password: password,
      );
      print("result 😂😂😂😂 : $result");

      if (!authenticationService.isEmailVerified()) {

        await authenticationService.logOut();
        navigationService.clearTillFirstAndShow(Routes.emailValidationView);
        return;
      }

      if (result) {
        if (!authenticationService.isRequestedAuthInApp) {
          navigationService.clearStackAndShow(Routes.bottomTabsApp);
        } else {
          navigationService.back();
        }
      } else {
        await dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
      setBusy(false);
    } catch (e) {
      snackbarService.showSnackbar(
          message:
              'Adresse mail ou mot de passe incorrect !', //getErrorMessageFromFirebaseException(e as FirebaseException),
          title: 'Echec de connection');
      setBusy(false);
    }
  }

  Future authenticateWithGoogle() async {
    setBusyForObject(socialProfileLoading, true);
    try {
      var result = await authenticationService.authenticateWithGoogle();

      if (result['isNewUser']) {
        await collectionService.createDefaultCollection();
      }

      if (result['authSuccess']) {
        if (!authenticationService.isRequestedAuthInApp)
          navigationService.clearStackAndShow(Routes.bottomTabsApp);
        else
          navigationService.back();
      } else {
        await dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } catch (e) {
      logger.e(e);
      snackbarService.showSnackbar(
          message: getErrorMessageFromFirebaseException(e as FirebaseException),
          title: 'Login Failure');
      setBusy(false);
    }
    setBusyForObject(socialProfileLoading, false);
  }

  Future authenticateWithFacebook() async {
    print('authenticateWithFacebook');
    setBusyForObject(socialProfileLoading, true);
    try {
      var result = await authenticationService.authenticateWithFacebook();

      if (result['isNewUser']) {
        await collectionService.createDefaultCollection();
      }

      if (result['authSuccess']) {
        if (!authenticationService.isRequestedAuthInApp)
          navigationService.clearStackAndShow(Routes.bottomTabsApp);
        else
          navigationService.back();
      } else {
        await dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } on FirebaseException catch (e) {
      print(e);
      snackbarService.showSnackbar(
        message:
            'Votre connection au serveur a échoué !', //getErrorMessageFromFirebaseException(e),
        title: 'Echec de connection ',
      );
      setBusy(false);
    }
    setBusyForObject(socialProfileLoading, false);
  }

  Future checkAppleSignInAvailable() async {
    setBusy(true);
    // _isAppleSignInAvailable =
    //     await authenticationService.isAppleSignInAvailable();
    // print('isAvailable $_isAppleSignInAvailable');
    setBusy(false);
  }

  void resetSignUpProcess() {
    locator<SignupProcessViewModel>().resetSignUpProcess();
  }

  void navigateToSignUpView() {
    navigationService.replaceWith(Routes.signUpView);
  }

  void navigateToResetPassword() {
    navigationService.navigateTo(Routes.passwordRecoveryView)?.then((value) {
      if (value)
        snackbarService.showSnackbar(
            title: 'Email de recuperation envoyé',
            message:
                'Consulter votre email pour continuer la procedure de recuperation de votre mot de passe.');
    });
  }

  skipAuthentication() {
    if (!authenticationService.isRequestedAuthInApp)
      navigationService.clearStackAndShow(Routes.bottomTabsApp);
    else
      navigationService.back();
  }

  @override
  void dispose() {
    print('view model login disposed');
    authenticationService.setRequestedAuthInAppState(true);
    super.dispose();
  }
}
