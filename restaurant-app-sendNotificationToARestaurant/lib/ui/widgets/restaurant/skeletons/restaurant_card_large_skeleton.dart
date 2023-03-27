// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class RestaurantCardLargeSkeleton extends StatelessWidget {
  const RestaurantCardLargeSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      spacing: EdgeInsets.only(right: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        width: 280,
      ),
    );
  }
}
