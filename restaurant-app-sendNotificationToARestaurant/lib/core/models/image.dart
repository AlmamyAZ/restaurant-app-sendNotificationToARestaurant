import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

class Image {
  final String? id;
  final String? userId;
  final String? comment;
  final String? restaurantId;
  final String? imageUrl;
  final String? subject;
  final String? userImageProfileUrl;
  final String? userName;
  final DateTime? createdAt;

  Image({
    this.id,
    this.userId,
    this.comment,
    this.restaurantId,
    this.imageUrl,
    this.subject,
    this.userImageProfileUrl,
    this.userName,
    this.createdAt,
  });

  Image.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        userId = json['userId'],
        comment = json['comment'],
        restaurantId = json['restaurantId'],
        imageUrl = json['imageUrl'],
        subject = json['subject'],
        userImageProfileUrl = json['userImageProfileUrl'],
        userName = json['userName'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['restaurantId'] = this.restaurantId;
    data['subject'] = this.subject;
    data['userImageProfileUrl'] = this.userImageProfileUrl;
    data['userName'] = this.userName;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  static Image serializeImage(Map<String, dynamic> data, String id) {
    if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now();
    } else {
      data['createdAt'] = data['createdAt'].toDate();
    }
    UploadService _uploadService = locator<UploadService>();
    data['imageUrl'] =
        _uploadService.getImageLinkBySize(primaryUrl: data['imageUrl']);
    return Image.fromJson(data, id);
  }
}
