// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPress;
  final String title;
  final Color color;
  final Color textColor;

  PrimaryButton(
      {required this.title,
      this.color = primaryColor,
      this.onPress,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          color,
        ),
      ),
      onPressed: onPress,
      child: Text(title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}
