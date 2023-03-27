// Dart imports:
import 'dart:async';
import 'dart:typed_data';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

@injectable
class UploadService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  double? _downloadProgress = 0;
  double? get downloadProgress => _downloadProgress;

  final ImagePicker _picker = ImagePicker();

  Future<bool> checkIfImageValid(XFile asset) async {
    Uint8List byteData = await asset.readAsBytes();
    return byteData.buffer.lengthInBytes <= 3092943;
  }

  Future deleteImage(String imageLink) async {
    firebase_storage.Reference reference = storage.refFromURL(imageLink);
    await reference.delete();
  }

  String getImageLinkBySize(
      {required String primaryUrl, String size = '1000x1000'}) {
    String withOutToken = primaryUrl.split('&')[0];

    List<String> splitdUrl = withOutToken.split('.');
    String lastElement = splitdUrl.removeLast();
    String firstElement = splitdUrl.join('.');

    String resizedUrl = '${firstElement}_$size.$lastElement';
    return resizedUrl;
  }

  List<String> getImagesLinksBySize(
      {required List<String> primaryUrls, String size = '1000x1000'}) {
    print('hello word 👋👋👋');
    return primaryUrls.map((primaryUrl) {
      return getImageLinkBySize(primaryUrl: primaryUrl, size: size);
    }).toList();
  }

  Future deleteMultiImages(List<String> imageLinks) async {
    for (String imageLink in imageLinks) {
      await deleteImage(imageLink);
    }
  }

  Future imagePicker({
    int maxImages = 1,
    bool enableCamera = true,
  }) async {
    List<XFile>? images = await _picker.pickMultiImage();
    return images;
  }

  Future<List<String>> saveMultipleImages(
      {required List<XFile> images,
      required String folderName,
      Function? notifyListners}) async {
    List<String> imageLinks = [];
    for (XFile image in images) {
      imageLinks.add(await saveImage(
          image: image,
          notifyListners: notifyListners,
          folderName: folderName));
    }

    return imageLinks;
  }

  Future<String> saveImage({
    required XFile image,
    Function? notifyListners,
    required String folderName,
  }) async {
    Uint8List imageData = await image.readAsBytes();
    String fileName = Uuid().v1() + image.name;
    firebase_storage.Reference reference = storage.ref('$folderName/$fileName');

    firebase_storage.UploadTask uploadTask = reference.putData(imageData);

    try {
      uploadTask.snapshotEvents.listen(
          (firebase_storage.TaskSnapshot snapshot) {
        _downloadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        if (notifyListners != null) notifyListners();

        if (snapshot.state == firebase_storage.TaskState.success) {
          _downloadProgress = null;
          if (notifyListners != null) notifyListners();
        }
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        print('error: ${uploadTask.snapshot}');

        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      });
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      print('Uploaded ${snapshot.bytesTransferred} bytes.');
      return await uploadTask.snapshot.ref.getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print(e.message);
    }

    return await reference.getDownloadURL();
  }
}
