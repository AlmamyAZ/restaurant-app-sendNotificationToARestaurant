// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/setup_bottom_sheet_ui.dart';

@injectable // Add decoration
class CommentViewModel extends StreamViewModel<List<Review>> {
  final String? restaurantId;
  final String? reviewId;

  bool isEditing = false;

  Review? activeComment;

  CommentViewModel({this.restaurantId, this.reviewId});

  // input controller
  TextEditingController commentControler = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  @override
  Stream<List<Review>> get stream =>
      reviewService.commentStream(reviewId, restaurantId);

  List<Review>? get respondReviews => data;

  void changeEditing() {
    setBusy(true);
    isEditing = !isEditing;
    setBusy(false);
  }

  Future deleteComment(Review comment) async {
    await reviewService.deleteComment(comment, restaurantId!, reviewId!);
  }

  Future addOrEditRespondReview(Review review) async {
    String comment = commentControler.text;
    try {
      await authenticationService.redirectIfNotConneted();
      isEditing
          ? await reviewService.editReviewsRespond(
              review, activeComment!.id!, comment)
          : await reviewService.addReviewsRespond(review, comment);

      commentControler.text = '';
      isEditing = false;
    } catch (e) {}
  }

  void editFunction(String comment) {
    setBusy(true);
    commentControler.text = comment;
  }

  void cancelEditing() {
    changeEditing();
    setBusy(true);
    commentControler.text = '';
    setBusy(false);
  }

  Future reportComment(Review review) async {
    await reviewService.reportComment(review);
    navigationService.back();
    snackbarService.showSnackbar(
      message: 'merci pour votre contribution',
      title: 'Succès',
    );
  }

  Future showBasicBottomSheet(Review comment, BuildContext context) async {
    activeComment = comment;

    SheetResponse? response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.comment,
      barrierDismissible: true,
      data: {
        'comment': comment,
        'deleteFunction': () => deleteComment(comment),
        'editFunction': () => editFunction(comment.comment),
      },
    );

    if (response == null) return null;

    if (response.responseData != null) {
      FocusScope.of(context).autofocus(commentFocusNode);

      changeEditing();
    }

    return response;
  }

  @override
  void dispose() {
    print('comment Reviews disposed!!');
    super.dispose();
  }
}
