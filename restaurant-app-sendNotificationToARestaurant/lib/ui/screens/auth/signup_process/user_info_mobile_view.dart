// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';
import 'package:restaurant_app/ui/shared/input_masks.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_overlay.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class UserInfoMobileView extends StatelessWidget {
  final FocusNode phoneFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupProcessViewModel>.reactive(
        viewModelBuilder: () => locator<SignupProcessViewModel>(),
        disposeViewModel: false,
        builder: (context, model, child) => BusyOverlay(
              show: model.isBusy, // make the model busy after create account
              title: 'Envoi du code...',
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Numero de téléphone',
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
                              'Entrez votre numero de telephone',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalSpaceMedium,
                            InputField(
                              placeholder: ' Votre numero de telephone',
                              prefix: '+224 ',
                              textInputType: TextInputType.phone,
                              formatters: [phoneNumberMaskFormatter],
                              controller: model.phoneController,
                              validator: phoneValidator,
                              fieldFocusNode: phoneFocusNode,
                              autofocus: true,
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FullFlatButton(
                                  title: 'Suivant',
                                  onPress: () async {
                                    if (_formKey.currentState!.validate() &&
                                        !model.isBusy) {
                                      await model.verifyPhoneNumber(context);
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
            ));
  }
}
