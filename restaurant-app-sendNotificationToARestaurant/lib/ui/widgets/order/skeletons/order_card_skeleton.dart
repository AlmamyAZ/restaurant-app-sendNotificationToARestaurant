// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';

class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: new BoxDecoration(
                      color: Color(0xFFf1f3f4),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContentPlaceholder.block(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 10),
                      ContentPlaceholder.block(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 7),
                    ],
                  ),
                  Spacer(),
                  ContentPlaceholder.block(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 8),
                ],
              ),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 15,
                  topSpacing: 10),
              ContentPlaceholder.block(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 7,
              ),
              ContentPlaceholder.block(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 7,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ContentPlaceholder.block(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10),
                  Spacer(),
                  ContentPlaceholder.block(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10),
                ],
              ),
            ],
          )),
    );
  }
}
