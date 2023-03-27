// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

class Adress {
  final String? id;
  final String? name;
  final String? district;
  final String? zone;
  final String? description;
  final String? plusCode;
  final LatLng? latLng;
  final String? contactNumber;
  // plus other fields to determine
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Adress({
    this.id,
    this.name,
    this.district,
    this.zone,
    this.description,
    this.plusCode,
    this.contactNumber,
    this.latLng,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  Adress.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        name = json['name'],
        district = json['district'],
        zone = json['zone'],
        description = json['description'],
        plusCode = json['plusCode'],
        latLng = json['latLng'],
        contactNumber = json['contactNumber'],
        isDefault = json['isDefault'],
        updatedAt = json['updatedAt'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['district'] = this.district;
    data['zone'] = this.zone;
    data['description'] = this.description;
    data['plusCode'] = this.plusCode;
    data['latLng'] = this.latLng;
    data['contactNumber'] = this.contactNumber;
    data['isDefault'] = this.isDefault;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  static Adress? serializeAdress(Map<String, dynamic>? data) {
    if (data == null) return null;
    data['createdAt'] = data['createdAt']?.toDate();
    data['updatedAt'] = data['updatedAt']?.toDate();
    data['latLng'] =
        mapService.convertGeoFireToCoordinates(data['latLng']['geopoint']);
    var adress = Adress.fromJson(data);
    return adress;
  }
}
