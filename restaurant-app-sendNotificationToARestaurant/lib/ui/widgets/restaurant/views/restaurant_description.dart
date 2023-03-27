// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/primary_button.dart';

class RestaurantDescription
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  Widget _buildSection(BuildContext context, String title, String content,
      BottomTabsRestaurantViewModel model) {
    const double width = 215;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        if (model.busy(model.restaurant))
          PlaceholderLines(width: width)
        else
          Text(
            content,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.fade,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
              context,
              'Description',
              model.busy(model.restaurant)
                  ? ''
                  : model.restaurant!.description!,
              model),
          SizedBox(
            height: 10,
          ),
          _buildSection(
              context,
              'Cuisines',
              model.busy(model.restaurant)
                  ? ''
                  : model.getJoinKitchenSpeciality(
                      model.restaurant!.kitchenSpeciality!,
                    ),
              model),
          SizedBox(
            height: 10,
          ),
          _buildSection(
              context,
              'Repas',
              model.busy(model.restaurant)
                  ? ''
                  : model.restaurant!.dishDay!.join(', '),
              model),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: PrimaryButton(
              color: Theme.of(context).primaryColor,
              title: 'Plus de details',
              onPress: model.busy(model.restaurant)
                  ? (){}
                  : () {
                      navigationService.navigateTo(
                          Routes.restaurantMoreDetailsScreen,
                          arguments: model);
                    },
            ),
          )
        ],
      ),
    );
  }
}

class PlaceholderLines extends StatelessWidget {
  const PlaceholderLines({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(2),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 60,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.9, height: 10),
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.9, height: 10),
                ContentPlaceholder.block(
                    width: MediaQuery.of(context).size.width * 0.7, height: 10),
              ],
            ),
          )),
    );
  }
}
