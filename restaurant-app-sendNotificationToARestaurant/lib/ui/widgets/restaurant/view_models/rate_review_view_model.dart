// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/core/models/user.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

// Add decoration
class RateReviewViewModel extends BaseViewModel {
  UploadService _uploadService = locator<UploadService>();

  bool isEdit = false;
  final description = TextEditingController();

  Review? currentReview;

  bool isLoading = false;

  RateReviewViewModel(Review? review) {
    if (review == null) return;
    isEdit = true;
    currentReview = review;
    description.text = review.comment;
    _reviewStart = review.rating!;
    _selectedIndex = subjet.indexOf(review.subject);
  }

  List subjet = ['Personnel', 'Etablissement', 'Nourriture'];

  List<XFile> _images = [];
  List<XFile> get images => _images;

  set setImages(List<XFile>? images) {
    if (images == null) return;
    setBusyForObject(images, true);
    _images = images;
    setBusyForObject(images, false);
  }

  void showSnacbar(String title, String message) {
    snackbarService.showSnackbar(
      message: message,
      title: title,
    );
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  double _reviewStart = 1;
  double get reviewStart => _reviewStart;

  void setSelectedIndex(int index) {
    setBusy(true);
    _selectedIndex = index;
    setBusy(false);
  }

  Future pickPicture() async {
    List<XFile>? result = await _uploadService.imagePicker();

    return result;
  }

  Future editReview() async {
    if (description.text.trim().isEmpty) return;

    setBusy(true);
    isLoading = true;
    setBusy(false);

    if (currentReview?.rating == reviewStart &&
        currentReview?.comment == description.text &&
        currentReview?.subject == subjet[selectedIndex]) {
      snackbarService.showSnackbar(
        message: 'veuillez modifier au moins la note ou la description',
        title: 'echec de modification',
      );

      setBusy(true);
      isLoading = false;
      setBusy(false);

      return;
    }

    try {
      List<String> imagesLink = await _uploadService.saveMultipleImages(
          images: images,
          notifyListners: null,
          folderName: '${currentReview!.restaurantId}/reviews');

      Map<String, dynamic> data = {
        'comment': description.text,
        'rating': reviewStart,
        'subject': subjet[selectedIndex],
        'imagesLinks': FieldValue.arrayUnion(imagesLink),
      };

      await reviewService.editReview(currentReview!.restaurantId,
          currentReview!.id, data, currentReview!.rating!);

      setBusy(true);
      isLoading = false;
      setBusy(false);

      navigationService.back(result: {'refreshData': true});
      snackbarService.showSnackbar(
        message: 'votre commentaire  a eté bien modifié',
        title: 'Succès',
      );
    } catch (e) {
      setBusy(true);
      isLoading = false;
      setBusy(false);
      snackbarService.showSnackbar(
        message: 'une erreur s\'est produite',
        title: 'Erreur',
      );
    }
  }

  Future addReview(String description, String restaurantId) async {
    if (description.trim().isEmpty) {
      snackbarService.showSnackbar(
        message: 'le champ description ne doit pas être vide',
        title: 'Erreur',
      );
      return;
    }

    setBusy(true);
    isLoading = true;
    setBusy(false);

    User currentUser = authenticationService.currentUser!;

    try {
      List<String> imagesLink = await _uploadService.saveMultipleImages(
        images: images,
        notifyListners: null,
        folderName: "$restaurantId/reviews",
      );

      Map<String, dynamic> data = {
        'userId': currentUser.id,
        'comment': description,
        'rating': reviewStart,
        'commentsCount': 0,
        'likesCounts': 0,
        'subject': subjet[selectedIndex],
        'createdAt': FieldValue.serverTimestamp(),
        'userImageProfileUrl': currentUser.userProfileUrl,
        'userName': currentUser.username,
        'restaurantId': restaurantId,
        'imagesLinks': imagesLink,
      };

      await reviewService.addReview(restaurantId, data);

      setBusy(true);
      isLoading = false;
      setBusy(false);

      navigationService.back(result: {'refreshData': true});
      snackbarService.showSnackbar(
        message: 'votre commentaire  a eté bien ajouté',
        title: 'Succès',
      );
    } catch (e) {
      setBusy(true);
      isLoading = false;
      setBusy(false);
      snackbarService.showSnackbar(
        message: 'une erreur s\'est produite',
        title: 'Erreur',
      );
    }
  }

  void setReviewStart(double index) {
    setBusy(true);
    _reviewStart = index;
    setBusy(false);
  }

  @override
  void dispose() {
    print('rate Reviews disposed!!');
    super.dispose();
  }
}
