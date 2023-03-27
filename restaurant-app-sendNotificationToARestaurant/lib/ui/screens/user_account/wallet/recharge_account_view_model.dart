import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/Exceptions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/payment.dart';
import 'package:restaurant_app/core/services/payement_service.dart';
import 'package:restaurant_app/ui/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class RechargeAccountViewModel extends BaseViewModel {
  TextEditingController _rechargeAmountController = TextEditingController();
  TextEditingController get rechargeAmountController =>
      _rechargeAmountController;

  FocusNode balanceFocusNode = new FocusNode();

  PayementService payementService = locator<PayementService>();

  final formKey = GlobalKey<FormState>();

  final rechargeAmountValidor = MultiValidator([
    RequiredValidator(errorText: '*Champs obligatoire'),
    EmailValidator(errorText: 'Format d\'email invalide'),
  ]);

  String _idTransaction = Uuid().v4();

  set idTransaction(String value) {
    _idTransaction = value;
    notifyListeners();
  }

  PaymentMethod? _paymentMethod;
  PaymentMethod? get paymentMethod => _paymentMethod;
  void handleRechargePaymentMethodChange(PaymentMethod value) {
    _paymentMethod = value;
    notifyListeners();
  }

  void showDialogV(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Vérification du paiement...'),
            content: Container(
              height: 100,
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Veuillez patienter pendant la vérification...'),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future rechargeWallet(context) async {
    setBusy(true);
    try {
      if (paymentMethod == null) {
        snackbarService.showCustomSnackBar(
          duration: const Duration(seconds: 5),
          variant: SnackbarType.warning,
          title: "Faites un choix",
          message: "Veuillez choisir une methode de paiement ",
        );
        return;
      }
      switch (paymentMethod) {
        case PaymentMethod.orangeMoney:
          await processOrderWithOM(context);
          break;
        default:
          print('No payment method selected');
          break;
      }

      setBusy(false);
    } on PayementError {
      setBusy(false);

      showFeedBack(isSuccess: false, message: 'Paiement échoué');
    } catch (e) {
      setBusy(false);
      showFeedBack(isSuccess: false, message: 'une erreur est survenue');
    }
  }

  Future? showFeedBack({bool isSuccess = true, String? message}) {
    // show toast
    return snackbarService.showCustomSnackBar(
      duration: const Duration(seconds: 5),
      variant: isSuccess ? SnackbarType.success : SnackbarType.error,
      title: isSuccess ? 'Paiement réussi' : 'Paiement échoué',
      message: message == null
          ? isSuccess
              ? 'Votre paiement a été effectué'
              : 'Echec du paiement vueillez réessayer'
          : message,
    );
  }

  Future processOrderWithOM(context) async {
    balanceFocusNode.unfocus();
    double amount = double.parse(_rechargeAmountController.text);
    var result = await payementService.payWithOM(_idTransaction, amount);
    String url = result['url'];
    String token = result['token'];
    String payToken = result['payToken'];
    await navigationService.navigateTo(Routes.omPaymentScreenView,
        arguments: url);
    showDialogV(context);
    String resultV = await payementService.verifyOmPayement(
      token,
      payToken,
      _idTransaction,
      amount,
    );
    navigationService.back();

    if (resultV != 'SUCCESS') throw new PayementError();
    _rechargeAmountController.clear();
    showFeedBack(isSuccess: true);
    await walletAccountService.rechargeWallet(
        amount, paymentMethod!.index, token, payToken);

    await showFeedBack(
        isSuccess: true, message: 'Votre compte a été rechargé avec succès');

    navigationService.back();
    navigationService.back();
  }
}
