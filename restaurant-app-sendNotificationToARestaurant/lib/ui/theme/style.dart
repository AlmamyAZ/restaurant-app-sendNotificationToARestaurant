// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    backgroundColor: Colors.red,
    indicatorColor: primaryColor,
    // textSelectionColor: primaryColor,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: primaryColor.withOpacity(0.5),
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
    ),
    primaryColor: primaryColor,
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      headline5: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      titleTextStyle: TextTheme(
        bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headline5: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cera Pro',
        ),
      ).headline6,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    fontFamily: 'Cera Pro',
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: primaryColorLight),
  );
}
