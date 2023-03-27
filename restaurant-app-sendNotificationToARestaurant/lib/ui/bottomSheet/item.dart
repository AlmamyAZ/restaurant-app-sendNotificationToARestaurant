// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';

class Item extends StatelessWidget {
  const Item({
    Key? key,
    this.icon,
    this.text,
    this.onTap,
    this.hasNext = true,
    this.logout = false,
    this.busy = false,
    this.show = true,
  }) : super(key: key);

  final IconData? icon;
  final String? text;
  final Function()? onTap;
  final bool hasNext;
  final bool logout;
  final bool busy;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return !show
        ? SizedBox()
        : Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        backgroundColor: logout ? Colors.red : primaryColor,
                        child: Icon(
                          icon,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        text!,
                        style: TextStyle(
                            color: logout ? Colors.red : Colors.blueGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  logout && busy ? CircularProgressIndicator() : Container(),
                  hasNext
                      ? Icon(
                          Icons.navigate_next,
                          color: primaryColor,
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
