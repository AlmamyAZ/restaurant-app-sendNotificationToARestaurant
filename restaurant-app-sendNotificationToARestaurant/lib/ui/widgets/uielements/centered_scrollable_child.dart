// Flutter imports:
import 'package:flutter/material.dart';

class CenteredScrollableChild extends StatelessWidget {
  const CenteredScrollableChild({
    Key? key,
     required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
