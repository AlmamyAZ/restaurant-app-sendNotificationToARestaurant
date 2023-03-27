// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class UserInfoNameView extends StatelessWidget {
  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupProcessViewModel>.reactive(
      viewModelBuilder: () => locator<SignupProcessViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Nom',
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
                      'Entrez votre Nom et Prenom',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    verticalSpaceMedium,
                    InputField(
                      placeholder: 'Prenom',
                      controller: model.firstnameController,
                      validator: codeValidator,
                      fieldFocusNode: firstnameFocusNode,
                      autofocus: true,
                      nextFocusNode: lastnameFocusNode,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      placeholder: 'Nom de famille',
                      controller: model.lastnameController,
                      validator: codeValidator,
                      fieldFocusNode: lastnameFocusNode,
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FullFlatButton(
                          title: 'Suivant',
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              navigationService
                                  .navigateTo(Routes.userInfoEmailView);
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
    );
  }
}
