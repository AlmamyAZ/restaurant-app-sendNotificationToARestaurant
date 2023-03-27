// Flutter imports:
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool styled;

  SectionTitle({required this.title, this.styled = false});

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xfffc4a1a), Color(0xfff7b733)],
    ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Container(
      padding: styled ? EdgeInsets.all(10) : null,
      child: Text(
        title,
        style: styled
            ? Theme.of(context).textTheme.headline5?.copyWith(
                  foreground: new Paint()..shader = linearGradient,
                  fontSize: 30,
                )
            : Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
