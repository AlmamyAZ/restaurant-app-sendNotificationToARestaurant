// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class SizedLogo extends StatelessWidget {
  final bool white;
  final double? width;
  SizedLogo({this.white = false,  this.width});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      !white ? 'assets/images/logo.png' : 'assets/images/logo.png',
      width: width == null ? screenWidthFraction(context, dividedBy: 3) : width,
    );
  }
}
