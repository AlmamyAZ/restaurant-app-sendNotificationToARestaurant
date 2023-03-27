// Dart imports:
import 'dart:async';

// Flutter imports:

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/firestore_exception_handler.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/user.dart' as model;
import 'package:restaurant_app/core/services/firebase_service/firebase_auth_service.dart';

@lazySingleton
class AuthenticationService with ReactiveServiceMixin {
  AuthenticationService() {
    print('** listening AuthenticationService begin');
    listenToReactiveValues([_currentUser]);
  }

  ReactiveValue<model.User?> _currentUser = ReactiveValue<model.User?>(initial);
  model.User? get currentUser => _currentUser.value;

  bool _isRequestedAuthInApp = false;
  bool get isRequestedAuthInApp => _isRequestedAuthInApp;

  bool _isLaunchedOnStartUpInitialisation = true;
  bool get isLaunchedOnStartUpInitialisation =>
      _isLaunchedOnStartUpInitialisation;

  static model.User? get initial => null;

  Future loginWithEmail({
    required String email,
    required String password,
  }) async {
    var authResult = await firebaseAuthenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    return authResult.uid != null;
  }

  Future redirectIfNotConneted() async {
    if (isUserLoggedIn()) return;
    await navigationService.navigateTo(Routes.loginView);
    if (firebaseAuth.currentUser == null) throw 'You are not connected';
  }

  Future redirectIfNotConnetedWithResult() async {
    if (isUserLoggedIn()) {
      // connected when the function started
      return true;
    }
    await navigationService.navigateTo(Routes.loginView);
    if (firebaseAuth.currentUser == null) throw 'You are not connected';

    // not connected when the function started
    return false;
  }

  Future signUpWithEmail(
      {required String email,
      required String password,
      required String firstname,
      required String lastname,
      required String phoneNumber,
      required String username,
      required PhoneAuthCredential phoneAuthCredential}) async {
    FirebaseAuthenticationResult authResult =
        await firebaseAuthenticationService.createAccountWithEmail(
      email: email,
      password: password,
    );

    model.User defaultUser = await userService.getUser('defaultUser');

    // update currentUserInfos

    await firebaseAuth.currentUser?.updateDisplayName('$firstname $lastname');
    await firebaseAuth.currentUser?.updatePhotoURL(defaultUser.userProfileUrl);

    // create a new user profile on firestore
    _createUserDocument(
      id: authResult.uid!,
      email: email,
      firstname: firstname,
      lastname: lastname,
      phoneNumber: phoneNumber,
      username: username,
      userProfileUrl: defaultUser.userProfileUrl!,
    );
    return authResult.uid != null;
  }

  Future authenticateWithGoogle() async {
    FirebaseAuthenticationResult authResult =
        await firebaseAuthenticationService.signInWithGoogle();

    if (authResult.hasError) {
      throw FirebaseCustomException(
        code: 'Custom-error message',
        message: authResult.errorMessage!,
      );
    }

    if (authResult.isNewUser!) {
      // create a new user profile on firestore
      _createUserDocument(
        id: authResult.uid!,
        email: firebaseAuth.currentUser!.email!,
        firstname: firebaseAuth.currentUser!.displayName!
            .split(' ')
            .getRange(
                0, firebaseAuth.currentUser!.displayName!.split(' ').length - 1)
            .join(' '),
        lastname: firebaseAuth.currentUser!.displayName!.split(
            ' ')[firebaseAuth.currentUser!.displayName!.split(' ').length - 1],
        phoneNumber: firebaseAuth.currentUser!.phoneNumber,
        username: firebaseAuth.currentUser!.displayName!,
        userProfileUrl: firebaseAuth.currentUser!.photoURL!,
      );
    }

    return {
      'authSuccess': authResult.uid != null,
      'isNewUser': authResult.isNewUser
    };
  }

  Future authenticateWithFacebook() async {
    FirebaseAuthenticationResult authResult =
        await firebaseAuthenticationService.signInWithFacebook();

    if (authResult.hasError) {
      throw FirebaseCustomException(
        code: 'Custom-error message',
        message: authResult.errorMessage!,
      );
    }

    if (authResult.isNewUser!) {
      firebaseAuth.currentUser?.updatePhotoURL(
          '${firebaseAuth.currentUser?.photoURL}?height=500&access_token=${authResult.facebookAcessToken}');
      // create a new user profile on firestore
      _createUserDocument(
        id: authResult.uid!,
        email: firebaseAuth.currentUser!.email!,
        firstname: firebaseAuth.currentUser!.displayName!
            .split(' ')
            .getRange(
                0, firebaseAuth.currentUser!.displayName!.split(' ').length - 1)
            .join(' '),
        lastname: firebaseAuth.currentUser!.displayName!.split(
            ' ')[firebaseAuth.currentUser!.displayName!.split(' ').length - 1],
        phoneNumber: firebaseAuth.currentUser!.phoneNumber,
        username: firebaseAuth.currentUser!.displayName!,
        userProfileUrl:
            '${firebaseAuth.currentUser!.photoURL}?height=500&access_token=${authResult.facebookAcessToken}',
      );
    }

    return {
      'authSuccess': authResult.uid != null,
      'isNewUser': authResult.isNewUser
    };
  }

  Future verifyNumber(
      String phoneNumber,
      void Function(PhoneAuthCredential) autoCheckFn,
      void Function(FirebaseAuthException) failedCeckFn,
      void Function(String, int?) codeSentFn,
      void Function(String) codeAutoTimeoutFn,
      int? resendToken) async {
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: autoCheckFn,
        verificationFailed: failedCeckFn,
        codeSent: codeSentFn,
        codeAutoRetrievalTimeout: codeAutoTimeoutFn,
        forceResendingToken: resendToken,
        timeout: Duration(seconds: 30));
  }

  Future verifyPhoneCredential(PhoneAuthCredential credential) async {
    await firebaseAuth.signInWithCredential(credential);
  }

  resetUser() {
    print('resetUser');
    _currentUser.value = null;
  }

  Future logOut() async {
    try {
      await firebaseAuthenticationService.logout();
    } catch (e) {
      return e;
    }
  }

  void addUserListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      await _populateCurrentUser(user);

      /// Disconnect users that are connected without verifying email
      /// Only if provider is email
      /// Fire only once when the app is initialising on startup
      if (verifyUnVerifiedEmail() && _isLaunchedOnStartUpInitialisation) {
        authenticationService.logOut();
        _setLaunchedOnStartUpInitialisationState(false);
      } else {
        _setLaunchedOnStartUpInitialisationState(false);
      }
    });
  }

  bool verifyUnVerifiedEmail() {
    return firebaseAuth.currentUser != null &&
        !firebaseAuth.currentUser!.emailVerified &&
        firebaseAuth.currentUser!.providerData[0].providerId == 'password';
  }

  bool isUserLoggedIn() {
    User? user = firebaseAuth.currentUser;
    return user != null;
  }

  Future _populateCurrentUser(User? user) async {
    model.User? userDoc;
    if (user != null) {
      userDoc = await userService.getUser(user.uid);
      _currentUser.value = userDoc;
    } else {
      resetUser();
    }
  }

  Future resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  bool isEmailVerified() {
    if (!firebaseAuth.currentUser!.emailVerified)
      navigationService.navigateTo(Routes.emailValidationView);

    return firebaseAuth.currentUser!.emailVerified;
  }

  // TODO: implement AppleSignIn
  // Future<bool> isAppleSignInAvailable() async {
  //   return await firebaseAuthenticationService.isAppleSignInAvailable();
  // }

  Future _createUserDocument({
    required String id,
    required String email,
    required String firstname,
    required String lastname,
    String? phoneNumber,
    required String username,
    required String userProfileUrl,
  }) async {
    _currentUser.value = model.User(
        id: id,
        email: email,
        firstname: firstname,
        lastname: lastname,
        phoneNumber: phoneNumber,
        username: username,
        userProfileUrl: userProfileUrl,
        createdAt: null,
        updatedAt: null);

    await userService.createUser(_currentUser.value!);
  }

  void setRequestedAuthInAppState(bool state) {
    _isRequestedAuthInApp = state;
  }

  void _setLaunchedOnStartUpInitialisationState(bool state) {
    _isLaunchedOnStartUpInitialisation = state;
  }
}
