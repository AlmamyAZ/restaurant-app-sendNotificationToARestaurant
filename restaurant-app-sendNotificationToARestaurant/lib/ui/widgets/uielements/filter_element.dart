// Flutter imports:
import 'package:flutter/material.dart';

class FilterElement extends StatelessWidget {
  final String label;
  final Function setIndexHandler;
  final int selectedIndex;
  final int idx;

  FilterElement({
    required this.label,
    required this.setIndexHandler,
    required this.selectedIndex,
    required this.idx,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (idx == selectedIndex) return;
        setIndexHandler(idx);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.easeIn,
        transform: idx == selectedIndex
            ? new Matrix4.identity().scaled(1.0, 1.0)
            : new Matrix4.identity().scaled(0.9, 0.9),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: idx == selectedIndex
              ? Theme.of(context).primaryColor
              : Colors.white,
        ),
        child: Row(children: [
          Text(
            label,
            style: TextStyle(
              color: idx == selectedIndex
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}
