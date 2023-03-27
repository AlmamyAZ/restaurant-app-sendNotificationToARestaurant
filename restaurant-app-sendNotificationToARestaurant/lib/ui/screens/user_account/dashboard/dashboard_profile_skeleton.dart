// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class DashBoardProfileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      child: Column(
        children: [
          verticalSpaceMedium,
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: new BoxDecoration(
                    color: Color(0xFFf1f3f4),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    shape: BoxShape.circle,
                  ),
                ),
                verticalSpaceMedium,
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.5, height: 18),
                verticalSpaceTiny,
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.6, height: 10),
              ],
            ),
          ),
          horizontalSpaceSmall,
          Divider(),
        ],
      ),
    );
  }
}
