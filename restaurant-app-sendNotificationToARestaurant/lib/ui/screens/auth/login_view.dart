// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/auth/auth_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_overlay.dart';
import 'package:restaurant_app/ui/widgets/uielements/centered_scrollable_child.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => locator<AuthViewModel>(),
      onModelReady: (model) {
        model.checkAppleSignInAvailable();
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
            body: CenteredScrollableChild(
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
                      verticalSpaceMedium,
                      FullFlatButton(
                        title: "Continuer comme invité",
                        textColor: primaryColor,
                        width: screenWidth(context),
                        onPress: () {
                          model.skipAuthentication();
                        },
                        color: primaryColorLight,
                      ),
                      verticalSpaceSmall,
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
                      InputField(
                        placeholder: 'Email',
                        controller: emailController,
                        validator: emailValidator,
                        fieldFocusNode: emailFocusNode,
                        nextFocusNode: passwordFocusNode,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Mot de passe',
                        password: true,
                        controller: passwordController,
                        validator: passwordValidator,
                        fieldFocusNode: passwordFocusNode,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextLink(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              model.navigateToResetPassword();
                            },
                          )
                        ],
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BusyButton(
                            title: 'Se connecter',
                            busy: model.isBusy,
                            onPressed: () {
                              if (_formKey.currentState!.validate())
                                model.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                            },
                          )
                        ],
                      ),
                      verticalSpaceLarge,
                      TextLink(
                        'Créez un compte si vous êtes nouveaux.',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                        onPressed: () {
                          model.navigateToSignUpView();
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
