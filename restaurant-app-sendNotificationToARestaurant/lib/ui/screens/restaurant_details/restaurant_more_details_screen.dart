// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurant_presentation_without_provider.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class RestaurantMoreDetailsScreen extends StatelessWidget {
  static const String routeName = '/restaurant-more-details';

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
        ),
        verticalSpaceTiny,
        Text(
          content,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BottomTabsRestaurantViewModel model = ModalRoute.of(context)
        ?.settings
        .arguments as BottomTabsRestaurantViewModel;
    Restaurant restaurant = model.restaurant!;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Plus de description',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RestaurantPresentationWithoutProvider(model: model),
                if (model.restaurant!.phoneNumber != null)
                  TextLink(
                    'Appeler ${model.restaurant!.name!}\nau ${model.restaurant?.phoneNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      launchUrl(
                          Uri.parse("tel://${model.restaurant!.phoneNumber}"));
                    },
                  ),
                if (model.restaurant!.phoneNumber != null) Divider(),
                _buildSection(
                  context,
                  'Description',
                  restaurant.description!,
                ),
                verticalSpaceSmall,
                _buildSection(
                  context,
                  'Cuisines',
                  model.getJoinKitchenSpeciality(restaurant.kitchenSpeciality!),
                ),
                verticalSpaceSmall,
                _buildSection(
                  context,
                  'Repas',
                  restaurant.dishDay!.join(', '),
                ),
                verticalSpaceSmall,
                _buildSection(
                  context,
                  'Installations',
                  restaurant.installation!,
                ),
                Divider(),
                RestaurantAddress(
                  adress: restaurant.adress!,
                  position: restaurant.position!,
                )
              ],
            ),
          ),
        ));
  }
}

class RestaurantAddress extends StatelessWidget {
  final String? adress;
  final GeoPoint? position;
  RestaurantAddress({this.adress, this.position});

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
        ),
        verticalSpaceTiny,
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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            context,
            'Adresse',
            adress!,
          ),
          verticalSpaceSmall,
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5),
                      top: Radius.circular(5),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              icon: Icon(
                Icons.directions,
                color: Colors.white,
              ),
              label: Text(
                'Voir direction',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => launchMap(position!),
            ),
          ),
        ],
      ),
    );
  }
}
