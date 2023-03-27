// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    Key? key,
    this.private = false,
    required this.icon,
    required this.text,
     this.color,
     this.onTap,
    this.hasNext = true,
    this.logout = false,
  }) : super(key: key);

  final bool private;
  final IconData icon;
  final String text;
  final String? color;
  final Function()? onTap;
  final bool hasNext;
  final bool logout;

  @override
  Widget build(BuildContext context) {
    return !private
        ? InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: logout ? Colors.red : Colors.grey[100],
                        child: Icon(
                          icon,
                          size: 18,
                          color: logout ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            color: logout ? Colors.red : Colors.blueGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  hasNext
                      ? Icon(
                          Icons.navigate_next,
                          color: primaryColor,
                        )
                      : Container(),
                ],
              ),
            ),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }
}
