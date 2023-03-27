// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/core/services/algolia_service.dart';
import 'package:restaurant_app/core/services/notifications_service.dart';
import 'package:restaurant_app/core/services/order_service.dart';
import 'package:restaurant_app/core/services/wallet_account_service.dart';
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/services/cart_service.dart';
import 'package:restaurant_app/core/services/category_service.dart';
import 'package:restaurant_app/core/services/collection_service.dart';
import 'package:restaurant_app/core/services/dynamic_link_service.dart';
import 'package:restaurant_app/core/services/firebase_service/authentification_service.dart';
import 'package:restaurant_app/core/services/firebase_service/firebase_auth_service.dart';
import 'package:restaurant_app/core/services/firebase_service/firestore_service.dart';
import 'package:restaurant_app/core/services/food_service.dart';
import 'package:restaurant_app/core/services/general_service.dart';
import 'package:restaurant_app/core/services/maps_service.dart';
import 'package:restaurant_app/core/services/restaurant_service.dart';
import 'package:restaurant_app/core/services/review_service.dart';
import 'package:restaurant_app/core/services/user_service.dart';

/// This file only contains services that are declared as
/// @Singletons
/// @LazySingletons

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

final Logger logger = Logger(printer: PrettyPrinter());

final FirestoreService firestoreService = locator<FirestoreService>();
final FirebaseAuthenticationService firebaseAuthenticationService =
    FirebaseAuthenticationService(log: Logger(printer: PrettyPrinter()));
final AuthenticationService authenticationService =
    locator<AuthenticationService>();

final notificationService = locator<NotificationService>();
final UserService userService = locator<UserService>();

final CollectionService collectionService = locator<CollectionService>();
final RestaurantService restaurantService = locator<RestaurantService>();
final FoodService dishService = locator<FoodService>();
final GeneralService generalService = locator<GeneralService>();
final CategoryService categoriesService = locator<CategoryService>();
final DynamicLinkService dynamicLinkService = locator<DynamicLinkService>();
final ReviewService reviewService = locator<ReviewService>();
final CartService cartService = locator<CartService>();
final OrderService orderService = locator<OrderService>();

final MapService mapService = locator<MapService>();

final SnackbarService snackbarService = locator<SnackbarService>();
final NavigationService navigationService = locator<NavigationService>();
final BottomSheetService bottomSheetService = locator<BottomSheetService>();
final DialogService dialogService = locator<DialogService>();

final AlgoliaService algoliaService = locator<AlgoliaService>();
final WalletAccountService walletAccountService =
    locator<WalletAccountService>();
