// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/auth/auth_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_overlay.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Colors.grey,
      fontFamily: 'Cera Pro',
    );

    var linkStyle = TextStyle(
        color: Colors.blueAccent,
        fontFamily: 'Cera Pro',
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500);

    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => locator<AuthViewModel>(),
      onModelReady: (model) {
        model.resetSignUpProcess();
      },
      builder: (context, model, child) => BusyOverlay(
        show: model.busy(model.socialProfileLoading),
        title: 'Profile en cours de chargement...',
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: SizedLogo(width: 100),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      verticalSpaceLarge,
                      FullFlatButton(
                        icon: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.white,
                        ),
                        title: "Continuer avec Facebook",
                        textColor: Colors.white,
                        width: screenWidth(context),
                        onPress: () {
                          model.authenticateWithFacebook();
                        },
                        color: Color(0xFF4267B2),
                      ),
                      verticalSpaceSmall,
                      FullFlatButton(
                        title: "Continuer avec Google",
                        textColor: Colors.black,
                        width: screenWidth(context),
                        svgPath: 'assets/images/logo_icons/google_logo.png',
                        border: true,
                        onPress: () {
                          model.authenticateWithGoogle();
                        },
                        color: Colors.white,
                      ),
                      verticalSpaceSmall,
                      // only on ios
                      if (model.isAppleSignInAvailable)
                        FullFlatButton(
                          icon: FaIcon(
                            FontAwesomeIcons.apple,
                            color: Colors.white,
                          ),
                          title: "Continuer avec Apple",
                          textColor: Colors.white,
                          width: screenWidth(context),
                          onPress: () {},
                          color: Colors.black,
                        ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Divider(thickness: 1)),
                          horizontalSpaceTiny,
                          Text(
                            'ou',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          horizontalSpaceTiny,
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      verticalSpaceSmall,
                      FullFlatButton(
                        icon: FaIcon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        title: "Continuer avec Email",
                        textColor: Colors.white,
                        width: screenWidth(context),
                        onPress: () {
                          navigationService.navigateTo(Routes.userInfoNameView);
                        },
                        color: primaryColor,
                      ),
                      verticalSpaceMedium,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                style: textStyle,
                                text:
                                    "En continuant le processus, vous acceptez nos "),
                            TextSpan(
                                style: linkStyle,
                                text: "Conditions d'utilisations ",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                            TextSpan(style: textStyle, text: " et nos "),
                            TextSpan(
                                style: linkStyle,
                                text: "Politiques de confidentialitées",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                            TextSpan(style: textStyle, text: " ."),
                          ],
                        ),
                      ),
                      verticalSpaceLarge,
                      TextLink(
                        'Vous avez déja un compte ? Connectez vous.',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                        onPressed: () {
                          navigationService.navigateTo(Routes.loginView);
                        },
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
