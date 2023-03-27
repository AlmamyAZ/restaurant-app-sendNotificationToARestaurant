// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class BundlesSkeleton extends StatelessWidget {
  const BundlesSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ContentPlaceholder(
              spacing: EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 700,
                width: double.infinity,
              ),
            );
          },
          childCount: 4,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 4 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
