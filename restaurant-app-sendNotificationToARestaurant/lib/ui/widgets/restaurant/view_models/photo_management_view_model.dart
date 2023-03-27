// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/image.dart';
import 'package:restaurant_app/core/models/user.dart';
import 'package:restaurant_app/core/services/upload_service.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';

class PhotoManagementViewModel extends BaseViewModel {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  UploadService _uploadService = locator<UploadService>();

  PhotoModel _photoModel = locator<PhotoModel>();

  List subjet = ['Menu', 'Etablissement', 'Nourriture'];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isUploadingImage = false;
  bool get isUploadingImage => _isUploadingImage;

  bool _isImageValid = false;
  bool get isImageValid => _isImageValid;

  // double _downloadProgress = 0;
  double? get downloadProgress => _uploadService.downloadProgress;

  Future verifyImage(asset) async {
    setBusy(true);
    _isImageValid = await _uploadService.checkIfImageValid(asset);
    setBusy(false);
  }

  Future savePhotoReview({
    required XFile asset,
    String? description,
    String? restaurantId,
  }) async {
    if (!isImageValid) {
      snackbarService.showSnackbar(
        message: 'L\'image depasse 3MB, veuillez choisir une autre image',
        title: 'Erreur',
      );
      return;
    }
    setBusy(true);
    _isUploadingImage = true;
    setBusy(false);

    String imageUrl = await _uploadService.saveImage(
        folderName: 'restaurantImages',
        image: asset,
        notifyListners: notifyListeners);

    User currentUser = authenticationService.currentUser!;

    Map<String, dynamic> data = {
      'comment': description,
      'imageUrl': imageUrl,
      'restaurantId': restaurantId,
      'subject': subjet[selectedIndex],
      'userId': currentUser.id,
      'userImageProfileUrl': currentUser.userProfileUrl,
      'userName': currentUser.username,
      // 'createdAt': FieldValue.serverTimestamp(),
    };

    DocumentReference documentReference = await restaurantService
        .setImageComment(restaurantId: restaurantId!, data: data);

    Image photo = Image.serializeImage(data, documentReference.id);
    _photoModel.setAllPhotos = photo;

    switch (selectedIndex) {
      case 0:
        _photoModel.setmenuPhotos = photo;
        break;
      case 1:
        _photoModel.setrestaurantPhotos = photo;
        break;
      case 2:
        _photoModel.setfoodPhotos = photo;
        break;
    }

    setBusy(true);
    _isUploadingImage = false;
    setBusy(false);

    navigationService.back();
    snackbarService.showSnackbar(
      message: 'l\'image a eté bien ajouté',
      title: 'Succès',
    );
  }

  void setSelectedIndex(int index) {
    setBusy(true);
    _selectedIndex = index;
    setBusy(false);
  }

  @override
  void dispose() {
    print('photos disposed!!');
    super.dispose();
  }
}
