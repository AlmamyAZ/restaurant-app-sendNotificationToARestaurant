// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:restaurant_app/core/services/notifications_service.dart';
import 'package:restaurant_app/core/services/payement_service.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';

import '../core/services/algolia_service.dart';
import '../core/services/cart_service.dart';
import '../core/services/category_service.dart';
import '../core/services/collection_service.dart';
import '../core/services/dynamic_link_service.dart';
import '../core/services/firebase_service/authentification_service.dart';
import '../core/services/firebase_service/firestore_service.dart';
import '../core/services/food_service.dart';
import '../core/services/general_service.dart';
import '../core/services/maps_service.dart';
import '../core/services/order_service.dart';
import '../core/services/restaurant_service.dart';
import '../core/services/review_service.dart';
import '../core/services/upload_service.dart';
import '../core/services/user_service.dart';
import '../core/services/wallet_account_service.dart';
import '../ui/screens/auth/auth_view_model.dart';
import '../ui/screens/auth/signup_process_view_model.dart';
import '../ui/screens/food/food_view_model.dart';
import '../ui/screens/home/home_view_model.dart';
import '../ui/screens/map/restaurants_map_view_model.dart';
import '../ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import '../ui/screens/search_all_restaurants/restaurants_search_view_model.dart';
import '../ui/screens/startup/startup_viewmodel.dart';
import '../ui/screens/user_account/dashboard/dashboard_view_model.dart';
import '../ui/screens/user_account/notifications/notifications_view_model.dart';
import '../ui/screens/user_account/wallet/recharge_account_view_model.dart';
import '../ui/screens/user_account/settings/settings_view_model.dart';
import '../ui/screens/user_account/wallet/transaction_history_view_model.dart';
import '../ui/screens/user_account/user_profile/profile_view_model.dart';
import '../ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import '../ui/screens/user_account/user_profile/user_stream_view_model.dart';
import '../ui/screens/user_account/wallet/wallet_account_view_model.dart';
import '../ui/widgets/cart/view_models/restaurant_cart_checkout_view_model.dart';
import '../ui/widgets/cart/view_models/restaurant_cart_options_view_model.dart';
import '../ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import '../ui/widgets/category/view_models/categories.dart';
import '../ui/widgets/collection/view_models/collection_icon_view_model.dart';
import '../ui/widgets/collection/view_models/collections.dart';
import '../ui/widgets/order/view_models/order_details_view_model.dart';
import '../ui/widgets/order/view_models/orders_view_model.dart';
import '../ui/widgets/restaurant/view_models/comment_view_model.dart';
import '../ui/widgets/restaurant/view_models/like_view_model.dart';
import '../ui/widgets/restaurant/view_models/menu.dart';
import '../ui/widgets/restaurant/view_models/menu_item_view_model.dart';
import '../ui/widgets/restaurant/view_models/photo.dart';
import '../ui/widgets/restaurant/view_models/restaurant.dart';
import '../ui/widgets/restaurant/view_models/restaurants.dart';
import '../ui/widgets/restaurant/view_models/review.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => OrdersViewModel());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FoodService());
  locator.registerLazySingleton(() => CartService());
  locator.registerLazySingleton(() => CategoryService());
  locator.registerLazySingleton(() => CollectionService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => GeneralService());
  locator.registerLazySingleton(() => RestaurantService());
  locator.registerLazySingleton(() => ReviewService());
  locator.registerLazySingleton(() => SignupProcessViewModel());
  locator.registerLazySingleton(() => StartupViewModel());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserStreamViewModel());
  locator.registerFactory(() => WalletAccountViewModel());
  locator.registerFactory(() => AdressesViewModel());
  locator.registerFactory(() => RechargeAccountViewModel());
  locator.registerFactory(() => AuthViewModel());
  locator.registerFactory(() => CollectionIconViewModel());
  locator.registerFactory(() => CommentViewModel());
  locator.registerFactory(() => DashboardViewModel());
  locator.registerFactory(() => FoodViewModel());
  locator.registerFactory(() => NotificationsViewModel());
  locator.registerFactory(() => ProfileViewModel());
  locator.registerFactory(() => RestaurantCartOptionsViewModel());
  locator.registerFactory(() => RestaurantCartViewModel());
  locator.registerFactory(() => SettingsViewModel());
  locator.registerFactory(() => StreamLikeViewModel());
  locator.registerFactory(() => UploadService());
  locator.registerFactory(() => RestaurantCartCheckoutViewModel());
  locator.registerFactory(() => RestaurantsSearchViewModel());
  locator.registerFactory(() => OrderDetailsViewModel());
  locator.registerFactory(() => UserTransactionHistoryViewModel());
  locator.registerFactory(() => WalletAccountService());
  locator.registerFactory(() => PayementService());
  locator.registerSingleton(CategoriesModel());
  locator.registerSingleton(AlgoliaService());
  locator.registerSingleton(AllRestaurantsViewModel());
  locator.registerSingleton(CollectionModel());
  locator.registerSingleton(FirestoreService());
  locator.registerSingleton(HomeViewModel());
  locator.registerSingleton(MenuItemViewModel());
  locator.registerSingleton(MenuModel());
  locator.registerSingleton(PhotoModel());
  locator.registerSingleton(RestaurantViewModel());
  locator.registerSingleton(RestaurantsMapViewModel());
  locator.registerSingleton(RestaurantsModel());
  locator.registerSingleton(ReviewModel());
  locator.registerSingleton(MapService());
  locator.registerSingleton(NotificationService());
}
