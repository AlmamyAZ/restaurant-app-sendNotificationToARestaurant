// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class RestaurantCardSkeleton extends StatelessWidget {
  final bool grid;
  const RestaurantCardSkeleton({Key? key, this.grid = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = grid ? 200 : 200;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(grid ? 0 : 10),
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentPlaceholder.block(height: 90, width: width),
          SizedBox(
            height: 10,
          ),
          ContentPlaceholder.block(height: 10, width: width),
          ContentPlaceholder.block(height: 10, width: width),
          SizedBox(
            height: 5,
          ),
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.2, height: 10),
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.2, height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
