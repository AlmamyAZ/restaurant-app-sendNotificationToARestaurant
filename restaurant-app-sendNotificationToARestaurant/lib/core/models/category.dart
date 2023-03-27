// Flutter imports:

import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

class Category {
  final String? id;
  final String? name;
  final String? imgUrl;
  final String? imageHash;
  // final DateTime? createdAt;
  final int? nbPlaces;

  const Category({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.imageHash,
    // this.createdAt,
    this.nbPlaces,
  });

  const Category.noRequired({
    this.id,
    this.name,
    this.imgUrl,
    // this.createdAt,
    this.imageHash,
    this.nbPlaces,
  });

  Category.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        name = json['name'],
        imgUrl = json['imgUrl'],
        // createdAt = json['createdAt'],
        nbPlaces = json['nbPlaces'],
        imageHash = json['imageHash'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    // data['createdAt'] = this.createdAt;
    data['imageHash'] = this.imageHash;
    data['nbPlaces'] = this.nbPlaces;

    return data;
  }

  static Category serializeCategory(Map<String, dynamic> data, String id) {
    UploadService _uploadService = locator<UploadService>();
    data['imgUrl'] =
        _uploadService.getImageLinkBySize(primaryUrl: data['imageUrl']);
    return Category.fromJson(data, id);
  }
}
