// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/user_account/settings/settings_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    required this.text,
     this.trailingText,
     this.id,
     this.value,
    required this.onTap,
     this.hasNext = true,
  }) : super(key: key);

  final String text;
  final String? trailingText;
  final AppearenceModes? id;
  final AppearenceModes? value;
  final Function() onTap;
  final bool hasNext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Spacer(),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            horizontalSpaceTiny,
            hasNext
                ? Icon(
                    Icons.navigate_next,
                    color: primaryColor,
                  )
                : Container(),
            if (value != null && id == value)
              Icon(
                Icons.check_outlined,
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
