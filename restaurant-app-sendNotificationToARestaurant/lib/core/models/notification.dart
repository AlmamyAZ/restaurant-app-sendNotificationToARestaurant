// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderNotification {
  String id;
  bool isRead;
  String title;
  String content;
  Timestamp createdAt;
  OrderNotification({
    required this.id,
    required this.isRead,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  OrderNotification.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        isRead = json['isRead'],
        title = json['title'],
        content = json['content'],
        createdAt = json['createdAt'];
}
