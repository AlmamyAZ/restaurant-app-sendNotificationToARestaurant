// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class SeparatorSection extends StatelessWidget {
  const SeparatorSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          horizontalSpaceSmall,
          Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
