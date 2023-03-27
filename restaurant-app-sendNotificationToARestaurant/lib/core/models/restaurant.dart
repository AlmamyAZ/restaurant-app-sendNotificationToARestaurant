// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String? id;
  final String? waiterId;
  final String? name;
  final String? description;
  final String? adress;
  final String? installation;
  final String? phoneNumber;
  final String? imageUrl;
  final String? imageHash;
  final GeoPoint? position;
  final List<String>? categoriesId;
  final double? rating;
  final int? ratingCount;
  final int? priceRate;
  final List<Map<String, dynamic>>? openHours;
  final List<Map<String, dynamic>>? kitchenSpeciality;
  final List<String>? dishDay;
  final bool? openStatus;
  final DateTime? createdAt;

  Restaurant({
    this.id,
    this.waiterId,
    this.name,
    this.description,
    this.adress,
    this.installation,
    this.phoneNumber,
    this.imageUrl,
    this.imageHash,
    this.position,
    this.rating,
    this.ratingCount,
    this.priceRate,
    this.openHours,
    this.categoriesId,
    this.kitchenSpeciality,
    this.dishDay,
    this.openStatus,
    this.createdAt,
  });

  Restaurant.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        name = json['restaurant']['name'],
        waiterId = json['waiterId'],
        description = json['restaurant']['description'],
        adress = json['fullAdress'], //TODO: a changer
        installation = json['installation'],
        phoneNumber = json['restaurant']['phoneNumber'],
        imageUrl = json['restaurant']['imageUrl1000'],
        imageHash = json['restaurant']['imageHash'],
        position = json['position'],
        rating = json['rating']?.toDouble(),
        ratingCount = json['ratingCount'],
        priceRate = json['priceRate'], //TODO: a ajouter au niveau admin
        openHours = List<Map<String, dynamic>>.from(json['openHours']),
        kitchenSpeciality = json['kitchenspeciality'] != null
            ? List<Map<String, dynamic>>.from(json['kitchenspeciality'])
            : null,
        categoriesId = json['categoriesIds'] != null
            ? List<String>.from(json['categoriesIds'])
            : null,
        dishDay =
            json['dishDay'] != null ? List<String>.from(json['dishDay']) : null,
        openStatus = json['openStatus'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['waiterId'] = this.waiterId;
    data['categoriesId'] = this.categoriesId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['adress'] = this.adress;
    data['installation'] = this.installation;
    data['phoneNumber'] = this.phoneNumber;
    data['position'] = this.position;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['priceRate'] = this.priceRate;
    data['openHours'] = this.openHours;
    data['kitchenSpeciality'] = this.kitchenSpeciality;
    data['dishDay'] = this.dishDay;
    data['openStatus'] = this.openStatus;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    data['imageHash'] = this.imageHash;
    return data;
  }
}
