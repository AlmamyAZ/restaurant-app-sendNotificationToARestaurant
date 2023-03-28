// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class UserInfoMobileVerificationView extends StatelessWidget {
  final FocusNode phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupProcessViewModel>.reactive(
      viewModelBuilder: () => locator<SignupProcessViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Code de vérification',
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
                      'Nous vous avons envoyé un code de vérification au +224 ${model.phoneController.text}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    verticalSpaceMedium,
                    InputField(
                      placeholder: 'Code de vérification',
                      textInputType: TextInputType.phone,
                      controller: model.verificationCodeController,
                      fieldFocusNode: phoneFocusNode,
                      validator: codeValidator,
                      autofocus: true,
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            model.verifyPhoneNumber(context);
                          },
                          child: TextLink(
                            'Renvoyer le code',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalSpaceLarge,
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BusyButton(
                          title: 'Vérifier',
                          busy: model.isBusy,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              model.completeVerifyPhoneNumber();
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
