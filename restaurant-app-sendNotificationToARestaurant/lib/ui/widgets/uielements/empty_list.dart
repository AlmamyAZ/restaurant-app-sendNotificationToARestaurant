// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class EmptyList extends StatelessWidget {
  final Widget sign;
  final String message;

  const EmptyList({Key? key, required this.sign, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sign,
          verticalSpaceSmall,
          Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
