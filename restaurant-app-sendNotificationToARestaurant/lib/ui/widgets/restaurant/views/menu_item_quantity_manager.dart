// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class MenuItemQuantityManager extends StatelessWidget {
  final int quantity;
  final Function(int) onPress;

  const MenuItemQuantityManager({
    Key? key,
    required this.quantity,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColorLight),
            padding: MaterialStateProperty.all(EdgeInsets.all(5)),
            minimumSize: MaterialStateProperty.all(
              Size(
                30.0,
                30.0,
              ),
            ),
          ),
          child: Icon(
            Icons.remove,
            color: primaryColor,
            size: 25,
          ),
          onPressed: () {
            onPress(-1);
          },
          onLongPress: () {
            onPress(-1);
          },
        ),
        Text('$quantity',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColorLight),
            padding: MaterialStateProperty.all(EdgeInsets.all(5)),
            minimumSize: MaterialStateProperty.all(
              Size(
                30.0,
                30.0,
              ),
            ),
          ),
          child: Icon(
            Icons.add,
            color: primaryColor,
            size: 25,
          ),
          onPressed: () {
            onPress(1);
          },
          onLongPress: () {
            onPress(1);
          },
        ),
      ],
    );
  }
}
