// Flutter imports:
import 'package:flutter/material.dart';

class FoodGeneric {
  final String? id;
  final String? name;
  final Color? specialityId;
  final DateTime? createdAt;

  const FoodGeneric({
    this.id,
    this.name,
    this.specialityId,
    this.createdAt,
  });

  FoodGeneric.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        specialityId = json['specialityId'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['specialityId'] = this.specialityId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

var foodGeneric = [
  {
    "id": "d389c830ckkw1axwww",
    "name": "pizza",
    "specialityId": "",
    "createdAt": DateTime.utc(2020, 01, 29),
  },
];
