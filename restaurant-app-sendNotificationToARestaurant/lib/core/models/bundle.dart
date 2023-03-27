import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

class Bundle {
  String? id;
  String? name;
  String? imageUrl;
  String? imageHash;
  bool? hasCategories;
  List<String>? categories;
  // DateTime? createdAt;

  Bundle({
    this.id,
    this.name,
    this.imageUrl,
    this.imageHash,
    this.hasCategories,
    this.categories,
    // this.createdAt,
  });

  Bundle.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
    this.imageHash = json['imageHash'];
    this.hasCategories = json['hasCategories'];
    categories = List<String>.from(json['categories']);
    // this.createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['imageHash'] = this.imageHash;
    data['hasCategories'] = this.hasCategories;
    data['categories'] = this.categories;
    // data['createdAt'] = this.createdAt;
    return data;
  }

  static Bundle serializeBundle(Map<String, dynamic> data) {
    UploadService _uploadService = locator<UploadService>();
    data['imageUrl'] =
        _uploadService.getImageLinkBySize(primaryUrl: data['imageUrl']);

    if (data['categories'] == null) {
      data['categories'] = [];
    }
    var bundle = Bundle.fromJson(data);
    return bundle;
  }
}
