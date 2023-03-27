// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import './images_carousel.dart';
import './searchbar.dart';

class HomeSliverAppBar extends ViewModelWidget<HomeViewModel> {
  HomeSliverAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return SliverAppBar(
      title: SearchBar(),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      collapsedHeight: 60,
      centerTitle: true,
      backgroundColor: primaryColor,
      expandedHeight: 300,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0),
        collapseMode: CollapseMode.parallax,
        background: Container(
          height: double.infinity,
          width: double.infinity,
          child: ImageCarousel(
            sliders: model.sliders,
            onPress: model.navigateSliderTo
          ),
        ),
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
