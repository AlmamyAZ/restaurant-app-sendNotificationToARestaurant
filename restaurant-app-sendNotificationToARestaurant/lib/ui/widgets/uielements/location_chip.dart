// Flutter imports:
import 'package:flutter/material.dart';

class LocationChip extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color color;
  // final Color textColor;
  final double? fontSize;
  final Color? bgColor;

  LocationChip({required this.icon, required this.color, required this.text,  this.bgColor, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: fontSize != null ? 15 : fontSize,
            color: color,
          ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 90,
          child: Text(
            text,
            style: TextStyle(
              // color: textColor == null ? color : textColor,
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: fontSize == null ? null : fontSize,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
