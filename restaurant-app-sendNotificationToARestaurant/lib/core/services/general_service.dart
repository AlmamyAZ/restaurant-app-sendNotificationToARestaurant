// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:restaurant_app/core/models/bundle.dart';
import 'package:restaurant_app/core/models/commercial.dart';
import 'package:restaurant_app/core/models/slider.dart';

@lazySingleton
class GeneralService {
  final DocumentReference<Map<String, dynamic>> _bundlesDocumentReference =
      FirebaseFirestore.instance.collection('home').doc('bundles');

  final DocumentReference<Map<String, dynamic>> _slidersDocumentReference =
      FirebaseFirestore.instance.collection('home').doc('sliders');

  final CollectionReference _globalSettingsCollectionReference =
      FirebaseFirestore.instance.collection('globalSettings');

  final CollectionReference _commercialsCollectionReference =
      FirebaseFirestore.instance.collection('commercials');

  Future getStaticBundles() async {
    List<Bundle> bundles = [];
    try {
      var bundlesDocumentSnapshot = await _bundlesDocumentReference.get();
      if (bundlesDocumentSnapshot.exists) {
        var bundlesMap = bundlesDocumentSnapshot.data()!['bundles'];
        for (var bundle in bundlesMap) {
          bundles.add(Bundle.serializeBundle(bundle));
        }
        return bundles;
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getStaticSliders() async {
    List<Slider> sliders = [];
    try {
      var slidersDocumentSnapshot = await _slidersDocumentReference.get();
      if (slidersDocumentSnapshot.exists) {
        var slidersMap = slidersDocumentSnapshot.data()!['sliders'];
        for (var slider in slidersMap) {
          sliders.add(Slider.serializeSlider(slider));
        }
        return sliders;
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }

  Future getCommercials() async {
    try {
      var commercialsDocumentsSnapshot =
          await _commercialsCollectionReference.limit(10).get();
      if (commercialsDocumentsSnapshot.docs.isNotEmpty) {
        return serializeCommercials(commercialsDocumentsSnapshot);
      } else {
        return "document not exist";
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print('error: ${e.toString()}');

      return e.toString();
    }
  }

  Commercial serializeCommercial(Map<String, dynamic> data, commercialId) {
    data['createdAt'] = data['createdAt'].toDate();
    return Commercial.fromJson(data, commercialId);
  }

  List<Commercial> serializeCommercials(
      QuerySnapshot commercialsDocumentsSnapshot) {
    return commercialsDocumentsSnapshot.docs
        .map((snapshot) {
          return serializeCommercial(
              snapshot.data() as Map<String, dynamic>, snapshot.id);
        })
        .where((mappedItem) => mappedItem.title != null)
        .toList();
  }

  Future getAboutSettings() async {
    try {
      var aboutDocumentSnapshot =
          await _globalSettingsCollectionReference.doc('about').get();
      if (aboutDocumentSnapshot.exists) {
        return aboutDocumentSnapshot.data();
      } else {
        return {} as Map<String, dynamic>?;
      }
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }

      print(e.toString());
      return e.toString();
    }
  }
}
