// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';

@injectable
class StreamLikeViewModel extends StreamViewModel {
  ReviewModel _reviewModel = locator<ReviewModel>();

  final String? reviewId;
  int? likesCount = 0;

  int? commentsCount = 0;

  StreamLikeViewModel({
    this.reviewId,
    this.likesCount,
    this.commentsCount,
  });

  void initialiseReviewStats(likesCount, commentsCount) {
    setBusy(true);
    likesCount = likesCount;
    commentsCount = commentsCount;

    setBusy(false);
  }

  Future likeReview(Review review, state) async {
    try {
      //  To notify that a user is know connected
      bool reloadReviews =
          await authenticationService.redirectIfNotConnetedWithResult();

      if (!reloadReviews) {
        _reviewModel.releodReview();
      }

      await reviewService.likeReview(review, state);
      setBusy(true);
      likesCount = state ? likesCount! - 1 : likesCount! + 1;
      setBusy(false);
    } catch (e) {
      print(e);
    }
  }

  bool _isLiked = false;

  bool get isLiked => _isLiked;

  @override
  void onData(data) {
    setBusy(true);
    _isLiked = data == null ? false : data['state'];
    setBusy(false);
  }

  @override
  Stream get stream => reviewService.listenToLikestream(reviewId!);
}
