// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/setup_bottom_sheet_ui.dart';

@singleton // Add decoration
class ReviewModel extends BaseViewModel {
  // input controller
  TextEditingController commentControler = TextEditingController();

  List<Review> _allReviews = [];
  List<Review> get allReviews => _allReviews;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  set setAllReviews(Review review) {
    setBusyForObject(allReviews, true);

    _allReviews = [review, ...allReviews];
    setBusyForObject(allReviews, false);
  }

  set setFoodReviews(Review review) {
    setBusyForObject(foodReviews, true);

    _foodReviews = [review, ...foodReviews];
    setBusyForObject(foodReviews, false);
  }

  set setEstablishmentReviews(Review review) {
    setBusyForObject(establishmentReviews, true);

    _establishmentReviews = [review, ...establishmentReviews];
    setBusyForObject(establishmentReviews, false);
  }

  set setStaffReviews(Review review) {
    setBusyForObject(staffReviews, true);
    _staffReviews = [review, ...staffReviews];
    setBusyForObject(staffReviews, false);
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<Review> _foodReviews = [];
  List<Review> get foodReviews => _foodReviews;

  Map<String, dynamic>? _reviewsStats;
  Map<String, dynamic>? get reviewsStats => _reviewsStats;

  List<Review> _staffReviews = [];
  List<Review> get staffReviews => _staffReviews;

  List<Review> _establishmentReviews = [];
  List<Review> get establishmentReviews => _establishmentReviews;

  List<Review> _respondReviews = [];
  List<Review> get respondReviews => _respondReviews;

  double _reviewStart = 1;
  double get reviewStart => _reviewStart;

  Future<Map?> pushToAddReview(restaurantId, name) async {
    var result;
    if (authenticationService.currentUser == null) {
      result = await navigationService.navigateTo(Routes.loginView);
    } else {
      result = await navigationService.navigateTo(
        Routes.ratingReviewScreen,
        arguments: {'restaurantId': restaurantId, 'name': name},
      );
    }

    return result;
  }

  Future fetchReviewsStats(String restaurantId) async {
    setBusyForObject(reviewsStats, true);
    _reviewsStats = await reviewService.getReviewsStats(restaurantId);
    setBusyForObject(reviewsStats, false);
  }

  void setSelectedIndex(int index) {
    print('changing select index: $index');
    setBusy(true);
    _selectedIndex = index;
    setBusy(false);
  }

  Future reportReview(Review review) async {
    try {
      await authenticationService.redirectIfNotConneted();
      await reviewService.reportReview(review);
      navigationService.back();
      snackbarService.showSnackbar(
        message: 'merci pour votre contribution',
        title: 'Succès',
      );
    } catch (e) {}
  }

  Future deleteReview(Review review) async {
    try {
      await authenticationService.redirectIfNotConneted();
      await reviewService.deleteReview(review);
      releodReview();
    } catch (e) {}
  }

  Future fetchAllReviewsByRestaurantId(String id) async {
    print('fetchAllReview');
    setBusyForObject(allReviews, true);
    _allReviews = await reviewService.getReviewsByRestaurantId(id, null);
    setBusyForObject(allReviews, false);
  }

  Future fetchFoodReviewsByRestaurantId(String id) async {
    print('fetchFoodReview');
    setBusyForObject(foodReviews, true);
    _foodReviews =
        await reviewService.getReviewsByRestaurantId(id, 'Nourriture');
    setBusyForObject(foodReviews, false);
  }

  Future fetchEtablissementReviewsByRestaurantId(String id) async {
    print('fetchEtablissementReviews');
    setBusyForObject(establishmentReviews, true);
    _establishmentReviews =
        await reviewService.getReviewsByRestaurantId(id, 'Etablissement');
    setBusyForObject(establishmentReviews, false);
  }

  Future addRespondReview(Review review, String comment) async {
    try {
      await authenticationService.redirectIfNotConneted();
      await reviewService.addReviewsRespond(review, comment);
      commentControler.text = '';
    } catch (e) {}
  }

  Future fetchStaffReviewsByRestaurantId(String id) async {
    print('fetchstaffReview');
    setBusyForObject(staffReviews, true);
    _staffReviews =
        await reviewService.getReviewsByRestaurantId(id, 'Personnel');
    setBusyForObject(staffReviews, false);
  }

  Future gotoRatingReviewScreen(Review review) async {
    try {
      await authenticationService.redirectIfNotConneted();
      Map result = await navigationService
          .navigateTo(Routes.ratingReviewScreen, arguments: {
        'restaurantId': review.restaurantId,
        'review': review,
        'name': restaurant?.name,
      });

      if (result['refreshData']) releodReview();
    } catch (e) {}
  }

  Future showBasicBottomSheet(Review review) async {
    dynamic response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.review,
      barrierDismissible: true,
      data: {
        'review': review,
      },
    );
    return response;
  }

  Future deleteReviewPhoto(Review review, String photoUrl) async {
    await reviewService.deleteReviewPhoto(review, photoUrl);
    releodReview();
  }

  Future showReviewPhotoBottomSheet(Review review, int index) async {
    String photoUrl = review.imagesLinks![index];

    dynamic response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.galleryReview,
      barrierDismissible: true,
      data: {
        'deleteFunction': () => deleteReviewPhoto(review, photoUrl),
        'reviewUserId': review.userId,
      },
    );
    return response;
  }

  bool isEditable(reviewUserId) {
    return reviewUserId == firebaseAuth.currentUser?.uid;
  }

  Future gotoReviewDetail(Review review) async {
    await navigationService.navigateTo(
      Routes.reviewDisplayScreen,
      arguments: review,
    );
  }

  Future releodReview() async {
    String id = restaurant!.id!;
    await fetchAllReviewsByRestaurantId(id);
    await fetchFoodReviewsByRestaurantId(id);
    await fetchEtablissementReviewsByRestaurantId(id);
    await fetchStaffReviewsByRestaurantId(id);
    await fetchReviewsStats(id);
  }

  void setRestaurant(restaurant) {
    _restaurant = restaurant;
  }

  void runInitReviewsFetching(String id, Restaurant restaurant) {
    if (!restaurantService.restaurantReviewsInit) {
      fetchAllReviewsByRestaurantId(id);
      fetchFoodReviewsByRestaurantId(id);
      fetchEtablissementReviewsByRestaurantId(id);
      fetchStaffReviewsByRestaurantId(id);
      fetchReviewsStats(id);
      setRestaurant(restaurant);
      restaurantService.setRestaurantReviewsInit(true);
    }
  }

  @override
  void dispose() {
    print('Reviews disposed!');
    super.dispose();
  }
}
