// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/widgets/commercial/views/commercials_list.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/feeds_restaurants.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import '../../widgets/bundle/views/bundles.dart';
import '../../widgets/category/views/food_categories.dart';
import '../../widgets/food/views/food_discovery.dart';
import '../../widgets/restaurant/views/sponsored_restaurants.dart';
import '../../widgets/restaurant/views/top_restaurants.dart';
import '../../widgets/uielements/home_silver_app_bar.dart';
import '../../widgets/uielements/section_title.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => locator<HomeViewModel>(),
      onModelReady: (model) {
        model.fetchSliders();
        model.fetchBundles();
        model.fetchTopRestaurants();
        model.fetchFeedsRestaurants();
        model.fetchSponsoredRestaurants();
        model.fetchCommercials();
        model.fetchCategoriesHome();
        model.fetchDishes();

        // For authentication after we entered the MainScreen
        authenticationService.setRequestedAuthInAppState(true);
      },
      fireOnModelReadyOnce: true,
      disposeViewModel: false,
      builder: (context, model, child) => CustomScrollView(
        slivers: [
          HomeSliverAppBar(),
          Bundles(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                TopRestaurants(),
                FoodCategories(),
                SponsoredRestaurants(),
                SectionTitle(
                  title: 'Espace Decouverte',
                  styled: true,
                )
              ],
            ),
          ),
          FoodDiscovery(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: FullFlatButton(
                    title: 'Decouvrez plus de plats',
                    color: primaryColorLight,
                    textColor: primaryColor,
                    onPress: () {
                      model.navigateToDiscovery();
                    },
                  ),
                ),
                CommercialsList(),
              ],
            ),
          ),
          FeedsRestaurant()
        ],
      ),
    );
  }
}
