import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/collection.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

class Slider {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? type;
  final String? typeLabel;
  final String? imageUrl;
  final String? imageHash;
  final Collection? collection; //TODO: arranger ça
  final Map<String, dynamic>? restaurant;
  final String? externalLink;
  final String? externalLinkFallback;
  // final DateTime? createdAt;

  const Slider({
    this.id,
    this.title,
    this.subtitle,
    this.type,
    this.typeLabel,
    this.imageUrl,
    this.imageHash,
    this.collection,
    this.restaurant,
    this.externalLink,
    this.externalLinkFallback,
  });

  Slider.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['sliderDetails']['title'],
        subtitle = json['sliderDetails']['description'],
        type = json['type'],
        typeLabel = json['typeLabel'],
        imageUrl = json['imageUrl'],
        imageHash = json['imageHash'],
        restaurant = json['restaurant'],
        collection = json['type'] == 'collection'
            ? Collection.fromJson(json['collection'], '')
            : null,
        externalLink = json['externalLink'],
        externalLinkFallback = json['externalLinkFallback'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtitle'] = this.subtitle;
    data['type'] = this.type;
    data['typeLabel'] = this.typeLabel;
    data['imageUrl'] = this.imageUrl;
    data['imageHash'] = this.imageHash;
    data['collection'] = this.collection?.toJson();
    data['restaurant'] = this.restaurant;
    data['externalLink'] = this.externalLink;
    data['externalLinkFallback'] = this.externalLinkFallback;
    // data['createdAt'] = this.createdAt;
    return data;
  }

  static Slider serializeSlider(Map<String, dynamic> data) {
    UploadService _uploadService = locator<UploadService>();
    data['imageUrl'] =
        _uploadService.getImageLinkBySize(primaryUrl: data['imageUrl']);

    var slider = Slider.fromJson(data);
    return slider;
  }
}
