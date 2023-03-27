import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/payment.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/recharge_account_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import 'package:stacked/stacked.dart';

class RechargeAccountView extends StatelessWidget {
  const RechargeAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RechargeAccountViewModel>.reactive(
        viewModelBuilder: () => locator<RechargeAccountViewModel>(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Recharger mon compte"),
            ),
            body: Form(
              key: model.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceMedium,
                    Text(
                      "Choisir votre méthode de recharge",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      onTap: () {
                        model.handleRechargePaymentMethodChange(
                            PaymentMethod.orangeMoney);
                      },
                      leading: SizedBox(
                        width: 30,
                        child: Image.asset(
                          'assets/images/logo_icons/OM.png',
                        ),
                      ),
                      title: Text('Orange Money'),
                      trailing: Icon(
                        model.paymentMethod == PaymentMethod.orangeMoney
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                        size: 20,
                        color: primaryColor,
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      "Montant à recharger",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    verticalSpaceSmall,
                    InputField(
                      autofocus: false,
                      fieldFocusNode: model.balanceFocusNode,
                      controller: model.rechargeAmountController,
                      placeholder: "Montant à recharger en GNF",
                      textInputType: TextInputType.number,
                      validator: rechargeValidator,
                    ),
                    Container(
                      width: double.infinity,
                      child: model.isBusy
                          ? Center(child: CircularProgressIndicator())
                          : FullFlatButton(
                              onPress: () {
                                //validation
                                if (model.formKey.currentState!.validate()) {
                                  model.rechargeWallet(context);
                                }
                              },
                              title: "Continuer",
                              color: primaryColor,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
