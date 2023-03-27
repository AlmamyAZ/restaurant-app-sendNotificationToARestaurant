// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/menu.dart' as model;
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class MenuItemPresentation extends StatelessWidget {
  final model.MenuItem menuItem;

  MenuItemPresentation({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      menuItem.alias!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  formatCurrency(menuItem.price!),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          verticalSpaceMedium,
          Text(
            menuItem.description!,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
