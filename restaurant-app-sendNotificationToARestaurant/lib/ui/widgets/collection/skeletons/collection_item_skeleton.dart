// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class CollectionItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      width: double.infinity,
      height: double.infinity,
      spacing: EdgeInsets.all(0),
      child: ContentPlaceholder.block(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
