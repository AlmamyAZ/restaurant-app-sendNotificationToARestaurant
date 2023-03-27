// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_screen.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import '../../collections/restaurants_collections_screen.dart';
import '../../home/home_screen.dart';
import '../../map/restaurants_map_screen.dart';
import '../../user_account/dashboard/dashboard_screen.dart';
import '../constants/constants.dart';
import 'bottom_tabs_app_view_model.dart';

class BottomTabsApp extends StatefulWidget {
  @override
  _BottomTabsAppState createState() => _BottomTabsAppState();
}

class _BottomTabsAppState extends State<BottomTabsApp> {
  final Map<int, Widget> _viewCache = Map<int, Widget>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomTabsAppViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: getViewForIndex(model.currentTabIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          selectedItemColor: primaryColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(size: 25),
          currentIndex: model.currentTabIndex,
          type: BottomNavigationBarType.shifting,
          onTap: model.setTabIndex,
          items: TabBarItemsList.map(
            (item) => BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(item['icon']),
              label: item['title'],
            ),
          ).toList(),
        ),
      ),
      viewModelBuilder: () => BottomTabsAppViewModel(),
    );
  }

  Widget getViewForIndex(int index) {
    if (!_viewCache.containsKey(index)) {
      switch (index) {
        case 0:
          _viewCache[index] = HomeScreen();
          break;
        case 1:
          _viewCache[index] = RestaurantsListScreen();
          break;
        case 2:
          _viewCache[index] = RestaurantsCollectionsScreen();
          break;
        case 3:
          _viewCache[index] = RestaurantsMapScreen();
          break;
        case 4:
          _viewCache[index] = DashboardScreen();
          break;
      }
    }

    return _viewCache[index]!;
  }
}
