// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/services/firebase_service/firebase_auth_service.dart';

@lazySingleton
class SignupProcessViewModel extends BaseViewModel {
  bool _isAppleSignInAvailable = false;
  bool get isAppleSignInAvailable => _isAppleSignInAvailable;

  // SignUp Inputs
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final passwordController = TextEditingController();

  PhoneAuthCredential? _phoneAuthCredential;
  String? _verificationId;
  int? _resendToken;

  Future signUpWithEmail() async {
    try {
      setBusy(true);
      await authenticationService.signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        phoneNumber: phoneController.text,
        username: '',
        phoneAuthCredential: _phoneAuthCredential!,
      );

      await collectionService.createDefaultCollection();
      await authenticationService.logOut();
      navigationService.clearTillFirstAndShow(Routes.emailValidationView);
      setBusy(false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' ||
          e.code == 'email-already-in-use') {
        snackbarService.showSnackbar(
            message: getErrorMessageFromFirebaseException(e),
            title: 'Echec de l\'inscription');
      }

      setBusy(false);
      userService.deleteUser();
    }
  }

  Future verifyPhoneNumber(BuildContext context) async {
    try {
      String phoneNumber = '+224${phoneController.text}'.split(' ').join();

      setBusy(true);
      await authenticationService.verifyNumber(phoneNumber,
          // Autocompletion verification
          (PhoneAuthCredential credential) async {
        setBusy(false);
        _phoneAuthCredential = credential;
        navigationService.navigateTo(Routes.userInfoPasswordView);
      },
          // Verification error
          (FirebaseAuthException e) {
        snackbarService.showSnackbar(message: e.message!);
      },
          // CodeSent
          (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _resendToken = resendToken;

        setBusy(false);
        if (ModalRoute.of(context)?.settings.name !=
            Routes.userInfoMobileVerificationView) {
          await navigationService
              .navigateTo(Routes.userInfoMobileVerificationView);
          _resendToken = null;
          verificationCodeController.text = '';
          setBusy(false);
        } else {
          snackbarService.showSnackbar(
              message: 'Le code de verification a été renvoyé au $phoneNumber');
        }
      },
          // Autocompletion timeout
          (String verificationId) {
        snackbarService.showSnackbar(
            message: "Echec de la verification automatique");
        _verificationId = verificationId;
      }, _resendToken);
    } catch (e) {
      setBusy(false);
      logger.i(e.toString());
    }
  }

  Future completeVerifyPhoneNumber() async {
    setBusy(true);
    try {
      // Create a PhoneAuthCredential with the code

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: verificationCodeController.text,
      );
      _phoneAuthCredential = credential;
      await authenticationService.verifyPhoneCredential(credential);
      userService.deleteUser();

      setBusy(false);
      navigationService.replaceWith(Routes.userInfoPasswordView);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-verification-code')
        snackbarService.showSnackbar(
            message: 'Code de verification non valide');
      else if (e.code == 'session-expired')
        snackbarService.showSnackbar(
            message:
                'le code sms a expiré. Merci de renvoyer un nouveau code et reesayer.');
      else
        snackbarService.showSnackbar(message: e.toString());

      userService.deleteUser();
      setBusy(false);
    }
  }

  void resetSignUpProcess() {
    // SignUp Inputs
    firstnameController.text = '';
    lastnameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    verificationCodeController.text = '';
    passwordController.text = '';

    // Auth credentials
    _phoneAuthCredential = null;
    _verificationId = null;
    _resendToken = null;

    setBusy(false);
  }

  @override
  void dispose() {
    print('view model login disposed');
    super.dispose();
  }
}
