// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class RestaurantHeader extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  final Map<String, dynamic> restaurant;

  RestaurantHeader({required this.restaurant});

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    // Restaurant restaurant = model.restaurant;
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.blurBackground],
      titlePadding: EdgeInsets.all(0),
      centerTitle: true,
      collapseMode: CollapseMode.parallax,
      background: Container(
        height: 250,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //image code
            Container(
              constraints: BoxConstraints.expand(),
              child: CachedImageNetwork(
                  image: restaurant['imageUrl'],
                  imageHash: restaurant['imageHash']),
            ),
            //top grey shadow
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    end: const Alignment(0.0, 0.4),
                    begin: const Alignment(0.0, -1),
                    colors: <Color>[
                      Colors.black,
                      Colors.black12.withOpacity(0.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
