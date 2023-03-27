// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class StarsChip extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color color;
  // final Color textColor;
  final Color? bgColor;

  StarsChip({this.icon, required this.color, required this.text, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 15,
            color: color,
          ),
        if (icon != null) horizontalSpaceTiny,
        Container(
          child: Text(
            text,
            style: TextStyle(
              // color: textColor == null ? color : textColor,
              color: color,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
