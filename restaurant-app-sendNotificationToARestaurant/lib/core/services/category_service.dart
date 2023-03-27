// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/models/category.dart';

@lazySingleton
class CategoryService {
  final CollectionReference _categoriesCollectionReference =
      FirebaseFirestore.instance.collection('categories');
  final DocumentReference<Map<String, dynamic>>
      _categoriesHomeDocumentReference =
      FirebaseFirestore.instance.collection('home').doc('categories');

  Future getCategoriesHome() async {
    List<Category> categories = [];
    try {
      var categoryDocumentSnapshot =
          await _categoriesHomeDocumentReference.get();

      if (categoryDocumentSnapshot.exists) {
        var categoriesMap = categoryDocumentSnapshot.data()!['categories'];

        for (var category in categoriesMap) {
          categories.add(Category.serializeCategory(category, category['id']));
        }
        return categories;
      }
    } catch (e) {
      print('error: $e');
      if (e is PlatformException) {
        return e.message;
      }
      print('error: ${e.toString()}');
      return;
    }
  }

  Future getCategory(String categoryId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _categoriesCollectionReference.doc(categoryId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> categoryMap =
            documentSnapshot.data() as Map<String, dynamic>;
        categoryMap['createdAt'] = categoryMap['createdAt'].toDate();
        return Category.serializeCategory(categoryMap, documentSnapshot.id);
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      print('error: ${e.toString()}');
      return;
    }
  }

  Future getCateriesForBunble(List<String> categoriesId) async {
    List<Category> categories = [];
    try {
      for (var categoryId in categoriesId) {
        Category category = await getCategory(categoryId);
        categories.add(category);
      }
      return categories;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      print('error: ${e.toString()}');
      return;
    }
  }
}
