// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class FullFlatButton extends StatelessWidget {
  final Function()? onPress;
  final String title;
  final double? width;
  final bool border;
  final bool elevation;
  final FaIcon? icon;
  final Color color;
  final String? svgPath;
  final Color textColor;

  FullFlatButton(
      {required this.title,
      this.textColor = Colors.white,
      this.color = primaryColor,
      this.border = false,
      this.elevation = false,
       this.width,
       this.icon,
       this.svgPath,
       this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null
          ? screenWidth(context) - screenWidthFraction(context, dividedBy: 5)
          : width,
      height: 50,
      child: icon == null
          ? (border
              ? OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        side: BorderSide(width: 1.5, color: Colors.grey[400]!),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(color),
                  ),
                  onPressed: onPress,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (svgPath != null)
                          SizedBox(
                              width: 23,
                              height: 23,
                              child: Image.asset(svgPath!)),
                        horizontalSpaceTiny,
                        Text(title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: textColor))
                      ]),
                )
              : TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    backgroundColor: onPress == null
                        ? MaterialStateProperty.all(Colors.grey[350])
                        : MaterialStateProperty.all(color),
                    elevation: elevation ? MaterialStateProperty.all(1) : null,
                  ),
                  onPressed: onPress,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (svgPath != null)
                          SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset(svgPath!)),
                        Text(title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color:
                                    onPress == null ? Colors.grey : textColor))
                      ]),
                ))
          : TextButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(color),
                elevation: elevation ? MaterialStateProperty.all(1) : null,
              ),
              onPressed: onPress,
              icon: icon!,
              label: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
    );
  }
}
