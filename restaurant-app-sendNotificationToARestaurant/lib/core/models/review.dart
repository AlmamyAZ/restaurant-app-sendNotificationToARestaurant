import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

class Review {
  final String? id;
  final String? userId;
  final String comment;
  final double? rating;
  final int? commentsCount;
  final int? likesCounts;
  final String? subject;
  final String? userImageProfileUrl;
  final String? userName;
  final DateTime? createdAt;
  final String? restaurantId;
  final List<String>? imagesLinks;

  Review({
    this.id,
    this.userId,
    required this.comment,
    this.rating,
    this.commentsCount,
    this.likesCounts,
    this.subject,
    this.createdAt,
    this.userImageProfileUrl,
    this.userName,
    this.restaurantId,
    this.imagesLinks,
  });

  Review.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        userId = json['userId'],
        comment = json['comment'],
        rating = json['rating'],
        commentsCount = json['commentsCount'],
        likesCounts = json['likesCounts'],
        subject = json['subject'],
        userImageProfileUrl = json['userImageProfileUrl'],
        userName = json['userName'],
        createdAt = json['createdAt'],
        imagesLinks = List<String>.from(json['imagesLinks'] ?? []),
        restaurantId = json['restaurantId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['commentsCount'] = this.commentsCount;
    data['likesCounts'] = this.likesCounts;
    data['subject'] = this.subject;
    data['createdAt'] = this.createdAt;
    data['userImageProfileUrl'] = this.userImageProfileUrl;
    data['userName'] = this.userName;
    data['restaurantId'] = this.restaurantId;
    data['imagesLinks'] = this.imagesLinks;

    return data;
  }

  static Review serializeImage(Map<String, dynamic> data, String id) {
    UploadService _uploadService = locator<UploadService>();
    data['createdAt'] = data['createdAt'].toDate();

    if (data['imagesLinks'] != null) {
      data['imagesLinks'] = _uploadService.getImagesLinksBySize(
          primaryUrls: List<String>.from(data['imagesLinks']));
    }

    return Review.fromJson(data, id);
  }
}
