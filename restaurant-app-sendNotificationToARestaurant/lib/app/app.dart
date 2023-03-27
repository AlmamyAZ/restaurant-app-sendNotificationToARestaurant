// Package imports:
import 'package:restaurant_app/core/services/algolia_service.dart';
import 'package:restaurant_app/core/services/notifications_service.dart';
import 'package:restaurant_app/core/services/order_service.dart';
import 'package:restaurant_app/core/services/payement_service.dart';
import 'package:restaurant_app/core/services/wallet_account_service.dart';
import 'package:restaurant_app/ui/screens/cart/cart_checkout_screen.dart';
import 'package:restaurant_app/ui/screens/display_screens/restaurants_display_screen_category.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_search_view_model.dart';
import 'package:restaurant_app/ui/screens/startup/startup_map_selection_view.dart';
import 'package:restaurant_app/ui/screens/user_account/orders/order_details_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/orders/order_status_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/orders/orders_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/recharge_account_view.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/wallet_account_view.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/wallet_account_view_model.dart';
import 'package:restaurant_app/ui/views/om_payment_screen/om_payment_screen_view.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/order_details_view_model.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/orders_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_checkout_view_model.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/core/services/cart_service.dart';
import 'package:restaurant_app/core/services/category_service.dart';
import 'package:restaurant_app/core/services/collection_service.dart';
import 'package:restaurant_app/core/services/dynamic_link_service.dart';
import 'package:restaurant_app/core/services/firebase_service/authentification_service.dart';
import 'package:restaurant_app/core/services/firebase_service/firestore_service.dart';
import 'package:restaurant_app/core/services/food_service.dart';
import 'package:restaurant_app/core/services/general_service.dart';
import 'package:restaurant_app/core/services/maps_service.dart';
import 'package:restaurant_app/core/services/restaurant_service.dart';
import 'package:restaurant_app/core/services/review_service.dart';
import 'package:restaurant_app/core/services/upload_service.dart';
import 'package:restaurant_app/core/services/user_service.dart';
import 'package:restaurant_app/ui/screens/auth/auth_view_model.dart';
import 'package:restaurant_app/ui/screens/auth/email_validation_view.dart';
import 'package:restaurant_app/ui/screens/auth/login_view.dart';
import 'package:restaurant_app/ui/screens/auth/password_recovery_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process/user_info_email_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process/user_info_mobile_verification_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process/user_info_mobile_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process/user_info_name_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process/user_info_password_view.dart';
import 'package:restaurant_app/ui/screens/auth/signup_process_view_model.dart';
import 'package:restaurant_app/ui/screens/auth/signup_view.dart';
import 'package:restaurant_app/ui/screens/cart/cart_screen.dart';
import 'package:restaurant_app/ui/screens/cart/order_note_screen.dart';
import 'package:restaurant_app/ui/screens/collections/restaurants_collections_screen.dart';
import 'package:restaurant_app/ui/screens/collections/restaurants_display_screen_collection.dart';
import 'package:restaurant_app/ui/screens/display_screens/restaurants_display_screen_bundle.dart';
import 'package:restaurant_app/ui/screens/display_screens/dishes_display_screen_discoveries.dart';
import 'package:restaurant_app/ui/screens/display_screens/restaurants_specialities_screen.dart';
import 'package:restaurant_app/ui/screens/food/food_details_screen.dart';
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/screens/map/restaurants_map_view_model.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/menu_item_details_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/photo_review_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/rating_review_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_details_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/restaurant_more_details_screen.dart';
import 'package:restaurant_app/ui/screens/restaurant_details/review_display_screen.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import 'package:restaurant_app/ui/screens/startup/onboarding.dart';
import 'package:restaurant_app/ui/screens/startup/startup_view.dart';
import 'package:restaurant_app/ui/screens/startup/startup_viewmodel.dart';
import 'package:restaurant_app/ui/screens/tabs/app/bottom_tabs_app.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant.dart';
import 'package:restaurant_app/ui/screens/user_account/dashboard/dashboard_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/notifications/notification_details.dart';
import 'package:restaurant_app/ui/screens/user_account/notifications/notifications_list_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/notifications/notifications_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/about_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/apparance_mode_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/cgu_view.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/policy_view.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/settings_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/settings_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/user_pictures_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/profile_view.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/profile_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adress_map_selection_sreen.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_form_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_list_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_stream_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_options_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:restaurant_app/ui/widgets/category/view_models/categories.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collection_icon_view_model.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collections.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/comment_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/like_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/menu.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/menu_item_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/restaurants.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/user_transaction_history_view.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/recharge_account_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/transaction_history_view_model.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: UserTransactionHistoryView),
    MaterialRoute(page: WalletAccountView),
    MaterialRoute(page: RechargeAccountView),
    MaterialRoute(page: OnBoardingPage),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: StartupMapSelectionView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: UserInfoNameView),
    MaterialRoute(page: UserInfoEmailView),
    MaterialRoute(page: UserInfoMobileView),
    MaterialRoute(page: UserInfoMobileVerificationView),
    MaterialRoute(page: UserInfoPasswordView),
    MaterialRoute(page: EmailValidationView),
    MaterialRoute(page: PasswordRecoveryView),
    MaterialRoute(page: BottomTabsApp),
    MaterialRoute(page: BottomTabsRestaurant),
    MaterialRoute(page: RestaurantsSpecialitiesScreen),
    MaterialRoute(page: RestaurantsDisplayBundleScreen),
    MaterialRoute(page: RestaurantsDisplayCollectionScreen),
    MaterialRoute(page: RestaurantsDisplayCategoryScreen),
    MaterialRoute(page: RestaurantDetailsScreen),
    MaterialRoute(page: RestaurantMoreDetailsScreen),
    MaterialRoute(page: OrderDetailsScreen),
    MaterialRoute(page: OrderStatusScreen),
    MaterialRoute(page: CartScreen),
    MaterialRoute(page: OrdersScreen),
    MaterialRoute(page: OrderNoteScreen),
    MaterialRoute(page: MenuItemDetailsScreen),
    MaterialRoute(page: RatingReviewScreen),
    MaterialRoute(page: ReviewDisplayScreen),
    MaterialRoute(page: PhotoReviewScreen),
    MaterialRoute(page: FoodDetailsScreen),
    MaterialRoute(page: UserPicturesScreen),
    MaterialRoute(page: RestaurantsCollectionsScreen),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: AdressesListScreen),
    MaterialRoute(page: AdressFormScreen),
    MaterialRoute(page: AdressMapSelectionScreen),
    MaterialRoute(page: NotificationListScreen),
    MaterialRoute(page: NotificationDetails),
    MaterialRoute(page: SettingsScreen),
    MaterialRoute(page: ApparanceModeScreen),
    MaterialRoute(page: AboutScreen),
    MaterialRoute(page: GCUView),
    MaterialRoute(page: PolicyView),
    MaterialRoute(page: CartCheckoutScreen),
    MaterialRoute(page: OmPaymentScreenView),
    MaterialRoute(page: DishesDisplayScreenDiscoveries),
  ],
  dependencies: [
    //lazySingleton
    LazySingleton(classType: NavigationService), //
    LazySingleton(classType: DialogService), //
    LazySingleton(classType: SnackbarService), //
    LazySingleton(classType: BottomSheetService), //
    LazySingleton(classType: NotificationService), //

    LazySingleton(classType: DynamicLinkService),
    LazySingleton(classType: OrdersViewModel),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: FoodService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: CategoryService),
    LazySingleton(classType: CollectionService),
    LazySingleton(classType: OrderService),
    LazySingleton(classType: GeneralService),
    LazySingleton(classType: RestaurantService),
    LazySingleton(classType: ReviewService),
    LazySingleton(classType: SignupProcessViewModel),
    LazySingleton(classType: StartupViewModel),
    LazySingleton(classType: UserService),
    LazySingleton(classType: UserStreamViewModel),
    Factory(classType: WalletAccountViewModel),
    //Factory
    Factory(classType: AdressesViewModel),
    Factory(classType: RechargeAccountViewModel),
    Factory(classType: AuthViewModel),
    Factory(classType: CollectionIconViewModel),
    Factory(classType: CommentViewModel),
    Factory(classType: DashboardViewModel),
    Factory(classType: FoodViewModel),
    Factory(classType: NotificationsViewModel),
    Factory(classType: ProfileViewModel),
    Factory(classType: RestaurantCartOptionsViewModel),
    Factory(classType: RestaurantCartViewModel),
    Factory(classType: SettingsViewModel),
    Factory(classType: StreamLikeViewModel),
    Factory(classType: UploadService),
    Factory(classType: RestaurantCartCheckoutViewModel),
    Factory(classType: RestaurantsSearchViewModel),
    Factory(classType: OrderDetailsViewModel),
    Factory(classType: UserTransactionHistoryViewModel),
    Factory(classType: WalletAccountService),
    Factory(classType: PayementService),

    //Singleton
    Singleton(classType: CategoriesModel),
    Singleton(classType: AlgoliaService),
    Singleton(classType: AllRestaurantsViewModel),
    Singleton(classType: CollectionModel),
    Singleton(classType: FirestoreService),
    Singleton(classType: HomeViewModel),
    Singleton(classType: MenuItemViewModel),
    Singleton(classType: MenuModel),
    Singleton(classType: PhotoModel),
    Singleton(classType: RestaurantViewModel),
    Singleton(classType: RestaurantsMapViewModel),
    Singleton(classType: RestaurantsModel),
    Singleton(classType: ReviewModel),
    Singleton(classType: MapService),
  ],
)
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
