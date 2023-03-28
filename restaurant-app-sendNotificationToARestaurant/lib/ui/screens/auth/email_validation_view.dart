// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/centered_scrollable_child.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class EmailValidationView extends StatefulWidget {
  @override
  _EmailValidationViewState createState() => _EmailValidationViewState();
}

class _EmailValidationViewState extends State<EmailValidationView> {
  bool showSendValidationEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredScrollableChild(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceTiny,
              SizedLogo(),
              verticalSpaceMedium,
              SizedBox(
                width: screenWidth(context) -
                    screenWidthFraction(context, dividedBy: 4),
                child: Text(
                  'Création de compte reussie',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              verticalSpaceLarge,
              SizedBox(
                width: screenWidth(context) -
                    screenWidthFraction(context, dividedBy: 4),
                child: Text(
                  'Pour activer votre compte, veuillez cliquer sur le lien que nous vous avons envoyé par email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              verticalSpaceMedium,
              if (FirebaseAuth.instance.currentUser?.email != null &&
                  showSendValidationEmail)
                TextLink(
                  "Renvoyer l'email de vérification",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      showSendValidationEmail = false;
                    });
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    authenticationService.logOut();
                  },
                ),
              verticalSpaceMassive,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FullFlatButton(
                    width: screenWidth(context) - 80,
                    title: 'Retour à la connexion',
                    onPress: () {
                      authenticationService.setRequestedAuthInAppState(false);
                      navigationService.clearStackAndShow(Routes.loginView);
                    },
                  )
                ],
              ),
              verticalSpaceTiny,
            ],
          ),
        ),
      ),
    );
  }
}
