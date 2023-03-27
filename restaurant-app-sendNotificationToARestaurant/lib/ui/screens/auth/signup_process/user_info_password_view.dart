// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_overlay.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class UserInfoPasswordView extends StatelessWidget {
  final FocusNode passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupProcessViewModel>.reactive(
      viewModelBuilder: () => locator<SignupProcessViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => BusyOverlay(
        show: model.isBusy, // make the model busy after create account
        title: 'Creation de votre compte...',
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Mot de passe',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
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
                      verticalSpaceMedium,
                      Text(
                        'Entrez votre mot de passe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalSpaceMedium,
                      InputField(
                        placeholder: '',
                        password: true,
                        controller: model.passwordController,
                        validator: passwordValidator,
                        textInputType: TextInputType.visiblePassword,
                        fieldFocusNode: passwordFocusNode,
                        autofocus: true,
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FullFlatButton(
                            title: 'Creer mon compte',
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                model.signUpWithEmail();
                              }
                            },
                          )
                        ],
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
