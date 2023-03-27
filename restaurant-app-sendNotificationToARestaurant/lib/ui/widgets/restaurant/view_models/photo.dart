// Package imports:
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/image.dart';
import 'package:restaurant_app/core/services/upload_service.dart';
import 'package:restaurant_app/ui/setup_bottom_sheet_ui.dart';

@singleton // Add decoration
class PhotoModel extends BaseViewModel {
  UploadService _uploadService = locator<UploadService>();

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<Image> _allPhotos = [];
  List<Image> get allPhotos => _allPhotos;

  List<Image> _foodPhotos = [];
  List<Image> get foodPhotos => _foodPhotos;

  List<Image> _userPhotos = [];
  List<Image> get userPhotos => _userPhotos;

  List<Image> _restaurantPhotos = [];
  List<Image> get restaurantPhotos => _restaurantPhotos;

  List<Image> _menuPhotos = [];
  List<Image> get menuPhotos => _menuPhotos;

  set setAllPhotos(Image image) {
    setBusyForObject(allPhotos, true);
    _allPhotos = [image, ...allPhotos];
    setBusyForObject(allPhotos, false);
  }

  set setfoodPhotos(Image image) {
    setBusyForObject(foodPhotos, true);
    _foodPhotos = [image, ...foodPhotos];
    setBusyForObject(foodPhotos, false);
  }

  Future pickPicture(String restaurantId) async {
    try {
      await authenticationService.redirectIfNotConneted();
      List<XFile> result = await _uploadService.imagePicker();

      if (result.isEmpty) return;

      navigationService.navigateTo(Routes.photoReviewScreen,
          arguments: {'asset': result[0], 'restaurantId': restaurantId});
    } catch (e) {}
  }

  set setrestaurantPhotos(Image image) {
    setBusyForObject(restaurantPhotos, true);
    _restaurantPhotos = [image, ...restaurantPhotos];
    setBusyForObject(restaurantPhotos, false);
  }

  set setmenuPhotos(Image image) {
    setBusyForObject(menuPhotos, true);
    _menuPhotos = [image, ...menuPhotos];
    setBusyForObject(menuPhotos, false);
  }

  void setSelectedIndex(int index) {
    setBusy(true);
    _selectedIndex = index;
    setBusy(false);
  }

  Future showBasicBottomSheet(
      String restaurantId, String imageId, imageUrl) async {
    dynamic response = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.gallery,
      barrierDismissible: true,
      data: {
        'restaurantId': restaurantId,
        'imageId': imageId,
        'imageUrl': imageUrl,
      },
    );
    return response;
  }

  Future deletePicture(
      String restaurantId, String imageId, String imageUrl) async {
    await restaurantService.deletePhotoById(restaurantId, imageId, imageUrl);
    setBusyForObject(userPhotos, true);
    _userPhotos.removeWhere((element) => element.id == imageId);
    setBusyForObject(userPhotos, false);
  }

  Future fetchAllPhotosByRestaurantId(String id) async {
    print('fetchAllPhotos');
    setBusyForObject(allPhotos, true);
    _allPhotos = await restaurantService.getPhotosByRestaurantId(id, null);
    setBusyForObject(allPhotos, false);
  }

  Future fetchUserPicture() async {
    print('fetchAllPhotos');
    setBusyForObject(userPhotos, true);
    String? userId = firebaseAuth.currentUser?.uid;
    _userPhotos = await restaurantService.getUserPhotos(userId!);
    setBusyForObject(userPhotos, false);
  }

  Future fetchFoodPhotosByRestaurantId(String id) async {
    print('fetchFoodPhotos');
    setBusyForObject(foodPhotos, true);
    _foodPhotos =
        await restaurantService.getPhotosByRestaurantId(id, 'Nourriture');
    setBusyForObject(foodPhotos, false);
  }

  Future fetchRestaurantPhotosByRestaurantId(String id) async {
    print('fetchRestaurantPhotos');
    setBusyForObject(restaurantPhotos, true);
    _restaurantPhotos =
        await restaurantService.getPhotosByRestaurantId(id, 'Etablisement');
    setBusyForObject(restaurantPhotos, false);
  }

  Future fetchMenuPhotosByRestaurantId(String id) async {
    print('fetchMenuPhotos');
    setBusyForObject(menuPhotos, true);
    _menuPhotos = await restaurantService.getPhotosByRestaurantId(id, 'Menu');
    setBusyForObject(menuPhotos, false);
  }

  void runInitPhotosFetching(String id) {
    if (!restaurantService.restaurantPhotosInit) {
      fetchAllPhotosByRestaurantId(id);
      fetchFoodPhotosByRestaurantId(id);
      fetchRestaurantPhotosByRestaurantId(id);
      fetchMenuPhotosByRestaurantId(id);
      restaurantService.setRestaurantPhotosInit(true);
    }
  }

  @override
  void dispose() {
    print('photos disposed!!');
    super.dispose();
  }
}
