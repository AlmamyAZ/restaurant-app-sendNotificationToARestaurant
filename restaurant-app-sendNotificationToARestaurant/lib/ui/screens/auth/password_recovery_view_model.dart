// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

class PasswordRecoveryViewModel extends BaseViewModel {
  final emailController = TextEditingController();

  Future recoverPasword() async {
    try {
      setBusy(true);
      await authenticationService.resetPassword(emailController.text);
      setBusy(false);

      navigationService.back(result: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found')
        await dialogService.showDialog(
          title: 'Utilisateur introuvable',
          description:
              'Cet email ne correspond à aucun compte d\'utilisateur. Il peut avoir été suprimé',
        );
      else
        await dialogService.showDialog(
          title: 'Une erreur est survenue',
          description:
              'Erreur lors de l\'envoi de l\'email de recuperation. Veuillez reessayer !',
        );
      setBusy(false);
    }
  }

  @override
  void dispose() {
    print('password reset model disposed');
    super.dispose();
  }
}
