// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/auth/password_recovery_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class PasswordRecoveryView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordRecoveryViewModel>.reactive(
      viewModelBuilder: () => PasswordRecoveryViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Récupération de mot de passe',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpaceMedium,
                        Text(
                          'Entrez votre adresse email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    InputField(
                      placeholder: 'Email du compte à récuperer',
                      controller: model.emailController,
                      validator: emailValidator,
                      enterPressed: () {
                        if (_formKey.currentState!.validate())
                          model.recoverPasword();
                      },
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BusyButton(
                          title: 'Suivant',
                          busy: model.isBusy,
                          onPressed: () {
                            if (_formKey.currentState!.validate())
                              model.recoverPasword();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
