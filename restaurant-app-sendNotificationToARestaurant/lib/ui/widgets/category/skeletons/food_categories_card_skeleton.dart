// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class FoodCategoriesCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
        spacing: EdgeInsets.only(right: 10),
        width: 110,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFf1f3f4),
              ),
            ),
          ],
        ));
  }
}
