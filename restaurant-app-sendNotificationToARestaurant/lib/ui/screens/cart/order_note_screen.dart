// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import 'package:stacked/stacked.dart';

class OrderNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantCartViewModel>.reactive(
        viewModelBuilder: () => locator<RestaurantCartViewModel>(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Laisser une note',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpaceSmall,
                      Form(
                        key: model.formKey,
                        child: InputField(
                          maxLines: null,
                          maxLength: 150,
                          placeholder: 'Vos specifications',
                          controller: model.noteController,
                          validator: codeValidator,
                          additionalNote:
                              '*Vous pouvez specifier ici les demandes ou precisions concernant votre commandes. Elles seront communiquées au restaurant.',
                        ),
                      ),
                      verticalSpaceMedium,
                      FullFlatButton(
                          title: 'Confirmer',
                          onPress: () {
                            if (model.formKey.currentState!.validate())
                              model.setOrderNote(
                                model.noteController.text,
                              );
                          })
                    ],
                  )),
            ),
          );
        });
  }
}
