// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class CommercialCardSkeleton extends StatelessWidget {
  const CommercialCardSkeleton({Key? key}) : super(key: key);

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
        width: screenWidth(context) / 1.3,
      ),
    );
  }
}
