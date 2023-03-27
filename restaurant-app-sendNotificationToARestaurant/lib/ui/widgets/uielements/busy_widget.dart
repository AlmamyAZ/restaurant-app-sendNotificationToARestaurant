// Flutter imports:
import 'package:flutter/material.dart';

/// A button that shows a busy indicator in place of title
class BusySmallWidget extends StatefulWidget {
  final bool busy;
  final Widget child;

  BusySmallWidget({
    required this.busy,
    required this.child,
  });

  @override
  _BusySmallWidgetState createState() => _BusySmallWidgetState();
}

class _BusySmallWidgetState extends State<BusySmallWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      child: !widget.busy
          ? widget.child
          : CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }
}
