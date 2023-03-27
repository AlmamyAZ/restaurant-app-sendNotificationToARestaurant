// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_details_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_menu_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_photos_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_reviews_screen.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/views/restaurant_cart_button.dart';
import '../constants/constants.dart';

class BottomTabsRestaurant extends StatefulWidget {
  static const String routeName = '/bottom-tabs-restaurant';
  @override
  _BottomTabsRestaurantState createState() => _BottomTabsRestaurantState();
}

class _BottomTabsRestaurantState extends State<BottomTabsRestaurant> {
  final Map<int, Widget> _viewCache = Map<int, Widget>();
  final List<Map<String, Object>> _pages = [
    {'title': 'Presentation'},
    {'title': 'Menu'},
    {'title': 'Photos'},
    {'title': 'Avis'},
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> restaurant =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return ViewModelBuilder<BottomTabsRestaurantViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: ![0, 1, 2, 3].contains(model.currentTabIndex)
            ? AppBar(
                elevation: 1,
                title: Text(_pages[model.currentTabIndex]['title'] as String),
              )
            : null,
        body: getViewForIndex(model.currentTabIndex, restaurant),
        persistentFooterButtons: model.restaurantCart!.products!.isNotEmpty
            ? [
                RestaurantCartButton(
                  cart: model.restaurantCart!,
                )
              ]
            : null,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: BottomNavigationBar(
          elevation: model.restaurantCart!.products!.isNotEmpty ? 0 : null,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(size: 25),
          currentIndex: model.currentTabIndex,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: true,
          onTap: model.setTabIndex,
          items: TabBarRestaurantItemsList.map(
            (item) => BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(item['icon']),
              label: item['title'],
            ),
          ).toList(),
        ),
      ),
      viewModelBuilder: () =>
          BottomTabsRestaurantViewModel(id: restaurant['id']),
      onModelReady: (model) async {
        restaurantService.setRestaurantmenuInit(false);
        restaurantService.setRestaurantPhotosInit(false);
        restaurantService.setRestaurantReviewsInit(false);

        // Store uefull data globaly
        restaurantService.setCurrentRestaurantId(restaurant['id']);
        restaurantService.setCurrentRestaurantName(restaurant['name']);

        restaurantService.setCurrentRestaurantOpenHours(
            List<Map<String, dynamic>>.from(restaurant['openHours']));
        restaurantService
            .setCurrentRestaurantPhoneNumber(restaurant['phoneNumber']);

        model.fetchSponsoredRestaurants();

        await model.fetchRestaurant(restaurant['id']);
        model.fetchRelatedRestaurants();
      },
    );
  }

  Widget getViewForIndex(int index, Map<String, dynamic> restaurant) {
    if (!_viewCache.containsKey(index)) {
      switch (index) {
        case 0:
          _viewCache[index] = RestaurantDetailsScreen(restaurant: restaurant);
          break;
        case 1:
          _viewCache[index] = RestaurantMenuScreen();
          break;
        case 2:
          _viewCache[index] = RestaurantPhotosScreen();
          break;
        case 3:
          _viewCache[index] = RestaurantReviewsScreen();
          break;
      }
    }

    return _viewCache[index]!;
  }
}
