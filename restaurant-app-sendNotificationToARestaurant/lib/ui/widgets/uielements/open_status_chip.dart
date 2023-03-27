// Flutter imports:
import 'package:flutter/material.dart';

class OpenStatusChip extends StatelessWidget {
  final bool status;

  OpenStatusChip(this.status);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(2),
      alignment: Alignment.center,
      width: 56,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Text(
        status ? 'OUVERT' : 'FERMÉ',
        style: TextStyle(
          color: status ? Colors.green[500] : Colors.redAccent,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.fade,
      ),
    );
  }
}
