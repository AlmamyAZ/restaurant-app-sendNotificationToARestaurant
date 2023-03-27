// Flutter imports:
import 'package:flutter/material.dart';

class AppbarLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: 35,
      height: 3,
      child: CircularProgressIndicator(),
    );
  }
}
