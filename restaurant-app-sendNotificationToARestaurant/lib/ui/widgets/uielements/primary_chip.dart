// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class PrimaryChip extends StatelessWidget {
  final bool isActive;
  final Function() onPress;
  final String label;

  PrimaryChip({required this.isActive, required this.label, required this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(2),
        alignment: Alignment.center,
        width: 100,
        height: 25,
        decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : primaryColor,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
