// Flutter imports:
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/user.dart';
import 'package:restaurant_app/core/services/upload_service.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_stream_view_model.dart';

@injectable
class ProfileViewModel extends BaseViewModel {
  final UserStreamViewModel _userStreamViewModel =
      locator<UserStreamViewModel>();
  UploadService _uploadService = locator<UploadService>();

  bool _editMode = false;
  bool get editMode => _editMode;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? _profilePicture;
  String? get profilePicture => _profilePicture;

  Future fetchUserData() async {
    print('fetchUserData');
    setBusy(true);
    User? userData = _userStreamViewModel.user!;
    _profilePicture = userData.userProfileUrl!;
    emailController.text = userData.email!;
    firstnameController.text = userData.firstname!;
    lastnameController.text = userData.lastname!;
    usernameController.text = userData.username!;
    phoneController.text = userData.phoneNumber ?? '';
    setBusy(false);
  }

  Future pickProfilePicture() async {
    List<XFile> result = await _uploadService.imagePicker();
    if (result.isEmpty) return;
    bool isImageValid = await _uploadService.checkIfImageValid(result[0]);
    if (isImageValid) {
      setBusyForObject(profilePicture, true);
      _profilePicture = await _uploadService.saveImage(
          folderName: 'userImages',
          image: result[0],
          notifyListners: notifyListeners);
      await userService.editUser(
        User(
            id: firebaseAuth.currentUser?.uid, userProfileUrl: _profilePicture),
      );
      setBusyForObject(profilePicture, false);
    } else {
      snackbarService.showSnackbar(
        message: 'L\'image depasse 3MB, veuillez choisir une autre image',
        title: 'Erreur',
      );
    }
  }

  Future activateEditMode() async {
    setBusy(true);
    _editMode = true;
    setBusy(false);
  }

  Future saveChanges() async {
    setBusy(true);
    await userService.editUser(
      User(
        id: firebaseAuth.currentUser?.uid,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        username: usernameController.text,
        phoneNumber: phoneController.text,
        updatedAt: null,
      ),
    );
    _editMode = false;
    setBusy(false);
    snackbarService.showSnackbar(
        message: 'Vos modifications on été sauvegardé avec succees');
  }

  @override
  void dispose() {
    print('view model Account disposed');
    super.dispose();
  }
}
