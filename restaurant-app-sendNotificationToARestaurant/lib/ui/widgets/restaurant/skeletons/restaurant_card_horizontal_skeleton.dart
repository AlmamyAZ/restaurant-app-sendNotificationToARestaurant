// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class RestaurantCardHorizontalSkeleton extends StatelessWidget {
  const RestaurantCardHorizontalSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentPlaceholder.block(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ContentPlaceholder.block(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 20),
                          ContentPlaceholder.block(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 10),
                        ],
                      ),
                    ),
                    ContentPlaceholder.block(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContentPlaceholder.block(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 10),
                        ContentPlaceholder.block(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: 10),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
