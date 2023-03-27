import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

enum SnackbarType { success, error, warning }

const infoColor = const Color(0xFFBEDAF5);
const successColor = Colors.green;
const errorColor = Colors.red;
const warningColor = const Color(0xFFFFFCC00);

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  // Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: infoColor,
    titleColor: Colors.white,
    messageColor: Colors.white,
    borderWidth: 2,
    borderColor: Colors.white,
    mainButtonTextColor: Colors.black,
  ));

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.success,
    config: SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: successColor,
      textColor: Colors.white,
      borderRadius: 1,
      borderColor: Colors.white,
      dismissDirection: DismissDirection.horizontal,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: errorColor,
      titleColor: Colors.white,
      messageColor: Colors.white,
      borderRadius: 1,
    ),
  );
  service.registerCustomSnackbarConfig(
    variant: SnackbarType.warning,
    config: SnackbarConfig(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: warningColor,
        titleColor: Colors.white,
        messageColor: Colors.white,
        borderRadius: 1,
        messageTextStyle: TextStyle(fontWeight: FontWeight.bold),
        icon: Icon(Icons.warning, color: Colors.white)),
  );
}
