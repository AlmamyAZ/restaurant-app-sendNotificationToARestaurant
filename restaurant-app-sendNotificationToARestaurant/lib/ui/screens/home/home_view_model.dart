// Package imports:
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/models/commercial.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/bundle.dart';
import 'package:restaurant_app/core/models/category.dart' as MyCategory;
import 'package:restaurant_app/core/models/dish.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/core/models/slider.dart';
import 'package:restaurant_app/core/models/user.dart' as model;
import 'package:url_launcher/url_launcher.dart';

@singleton // Add decoration
class HomeViewModel extends BaseViewModel {
  model.User get user => authenticationService.currentUser!;

  List<Dish> _dishes = [];
  List<Dish> get dishes => _dishes;

  List<MyCategory.Category> _categoriesHome = [];
  List<MyCategory.Category> get categoriesHome => _categoriesHome;

  List<Slider> _sliders = <Slider>[];
  List<Slider> get sliders => _sliders;

  List<Bundle>? _bundles;
  List<Bundle>? get bundles => _bundles;

  List<Restaurant>? _topRestaurants;
  List<Restaurant>? get topRestaurants => _topRestaurants;

  List<Restaurant>? _feedsRestaurants;
  List<Restaurant>? get feedsRestaurants => _feedsRestaurants;

  List<Restaurant>? _sponsoredRestaurants;
  List<Restaurant>? get sponsoredRestaurants => _sponsoredRestaurants;

  List<Commercial>? _commercials;
  List<Commercial>? get commercials => _commercials;

  Future fetchBundles() async {
    print(firebaseAuth.currentUser.toString());
    print('fetchBundles');
    setBusyForObject(bundles, true);
    _bundles = await generalService.getStaticBundles();
    setBusyForObject(bundles, false);
  }

  Future fetchSliders() async {
    print('fetchSliders');
    setBusyForObject(sliders, true);
    _sliders = await generalService.getStaticSliders();
    setBusyForObject(sliders, false);
  }

  Future fetchTopRestaurants() async {
    print('fetchTopRestaurants');
    setBusyForObject(topRestaurants, true);
    _topRestaurants = await restaurantService.getTopRestaurants();
    setBusyForObject(topRestaurants, false);
  }

  Future fetchFeedsRestaurants() async {
    print('fetchFeedsRestaurants');
    setBusyForObject(feedsRestaurants, true);
    _feedsRestaurants = await restaurantService.getTopRestaurants();
    setBusyForObject(feedsRestaurants, false);
  }

  Future fetchSponsoredRestaurants() async {
    print('fetchSponsoredRestaurants');
    setBusyForObject(sponsoredRestaurants, true);
    _sponsoredRestaurants = await restaurantService.getSponsoredRestaurants();
    setBusyForObject(sponsoredRestaurants, false);
  }

  Future fetchCategoriesHome() async {
    print('fetchCategoriesHome');
    setBusyForObject(categoriesHome, true);
    _categoriesHome = await categoriesService.getCategoriesHome();
    setBusyForObject(categoriesHome, false);
  }

  Future fetchDishes() async {
    print('fetchDishes');
    setBusyForObject(dishes, true);
    _dishes = await dishService.getDishes();
    setBusyForObject(dishes, false);
  }

  Future fetchCommercials() async {
    print('fetchCommercials');
    setBusyForObject(commercials, true);
    _commercials = await generalService.getCommercials();
    setBusyForObject(commercials, false);
  }

  String getDistance(GeoPoint position) {
    return mapService.distanceBetweenTwoLocation(
        position.latitude, position.longitude);
  }

  void launchSocial(String url, String fallbackUrl) async {
    // Don't use canLaunch because of fbProtocolUrl (fb://)

    Uri uri = Uri.parse(url);
    Uri uriFallbackUrl = Uri.parse(fallbackUrl);
    try {
      bool launched = await launchUrl(
        uri,
      );
      if (!launched) {
        await launchUrl(
          uriFallbackUrl,
        );
      }
    } catch (e) {
      await launchUrl(
        uriFallbackUrl,
      );
    }
  }

  void navigateToSocial(Commercial commercial) {
    if (commercial.externalLink != null) {
      String externalLink;
      if (commercial.title == 'Facebook') {
        if (Platform.isIOS) {
          externalLink = 'fb://profile/${commercial.externalLink}';
        } else {
          externalLink = 'fb://page/${commercial.externalLink}';
        }
      } else {
        externalLink = commercial.externalLink!;
      }

      print(externalLink);

      launchSocial(externalLink, commercial.externalLinkFallback!);
    }
  }

  void navigateSliderTo(Slider slider) {
    if (slider.type == 'None') {
      return;
    }

    switch (slider.type) {
      case 'collection':
        navigationService.navigateTo(
          Routes.restaurantsDisplayCollectionScreen,
          arguments: slider.collection,
        );
        break;
      case 'restaurant':
        navigationService.navigateTo(Routes.bottomTabsRestaurant,
            arguments: slider.restaurant);
        break;
      case 'social':
        if (slider.externalLink != null) {
          String externalLink;
          if (slider.title == 'Facebook') {
            if (Platform.isIOS) {
              externalLink = 'fb://profile/${slider.externalLink}';
            } else {
              externalLink = 'fb://page/${slider.externalLink}';
            }
          } else {
            externalLink = slider.externalLink!;
          }

          print(externalLink);

          launchSocial(externalLink, slider.externalLinkFallback!);
        }
        break;
      default:
    }
  }

  void navigateToDiscovery() {
    navigationService.navigateTo(Routes.dishesDisplayScreenDiscoveries);
  }

  @override
  void dispose() {
    print('home disposed');
    super.dispose();
  }
}
