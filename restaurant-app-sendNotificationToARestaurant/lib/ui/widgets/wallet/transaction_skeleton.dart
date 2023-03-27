// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class WalletTransactionSkeleton extends StatelessWidget {
  const WalletTransactionSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
