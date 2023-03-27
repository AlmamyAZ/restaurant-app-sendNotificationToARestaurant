// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class OpaqueFullButton extends StatelessWidget {
  final Function()? onPress;
  final String title;

  OpaqueFullButton({required this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(primaryColorLight),
      ),
      onPressed: onPress,
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: primaryColor)),
    );
  }
}
