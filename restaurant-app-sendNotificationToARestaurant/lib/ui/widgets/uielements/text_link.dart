// Flutter imports:
import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function()? onPressed;
  const TextLink(this.text,
      { this.onPressed,
       this.style = const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  onPressed,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
