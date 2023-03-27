// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/core/models/user.dart';
import 'package:restaurant_app/core/services/upload_service.dart';

/// The service responsible for networking requests
@lazySingleton
class ReviewService {
  final String statsfinalString = '-reviews-count';

  UploadService _uploadService = locator<UploadService>();

  List subjet = ['Personnel', 'Etablissement', 'Nourriture'];

  // stream
  StreamController commentStreamControler = new BehaviorSubject<List<Review>>();

  Stream<Map<String, dynamic>?> listenToLikestream(String reviewId) {
    // ignore: close_sinks
    StreamController likeControler =
        new BehaviorSubject<Map<String, dynamic>?>();

    getUserLikeDocumentRef(reviewId).snapshots().listen((eventSnapshot) {
      Map<String, dynamic>? event =
          eventSnapshot.data() as Map<String, dynamic>?;
      likeControler.add(event);
    });

    return likeControler.stream as Stream<Map<String, dynamic>?>;
  }

  Stream<List<Review>> commentStream(reviewId, restaurantId) {
    getReviewResponseCollectionReference(restaurantId, reviewId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      List<Review> comments = event.docs.map((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Review.serializeImage(data, snapshot.id);
      }).toList();

      commentStreamControler.add(comments);
    });

    return commentStreamControler.stream as Stream<List<Review>>;
  }

  //stream
  DocumentReference getUserLikeDocumentRef(String reviewId) {
    String? userId = firebaseAuth.currentUser?.uid;

    return db
        .collection('users')
        .doc(userId)
        .collection('likesReview')
        .doc(reviewId);
  }

  String getReviewSubjectStringForStats(String subject) {
    String subjectName = '';
    switch (subject) {
      case 'Personnel':
        subjectName = 'staff$statsfinalString';
        break;

      case 'Etablissement':
        subjectName = 'establissement$statsfinalString';
        break;

      case 'Nourriture':
        subjectName = 'food$statsfinalString';
        break;
    }

    return subjectName;
  }

  DocumentReference getStatsReviewDocumentReference(String restaurantId) {
    return getReviewCollectionReference(restaurantId).doc('--stats-reviews--');
  }

  Future<Map<String, dynamic>> getReviewsStats(String restaurantId) async {
    DocumentSnapshot documentSnapshot =
        await getStatsReviewDocumentReference(restaurantId).get();
    return documentSnapshot.data() as Map<String, dynamic>;
  }

  CollectionReference getReviewCollectionReference(String restaurantId) {
    return db.collection('restaurants').doc(restaurantId).collection('reviews');
  }

  DocumentReference getReviewDocumentReference(
      String restaurantId, String reviewId) {
    return getReviewCollectionReference(restaurantId).doc(reviewId);
  }

  CollectionReference getReviewResponseCollectionReference(
      String restaurantId, String reviewId) {
    return getReviewDocumentReference(restaurantId, reviewId)
        .collection('comment');
  }

  Future addReview(
    String restaurantId,
    Map<String, dynamic> data,
  ) async {
    String subjectStats = getReviewSubjectStringForStats(data['subject']);

    DocumentReference restaurantRef =
        db.collection('restaurants').doc(data['restaurantId']);

    await db.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot = await transaction.get(restaurantRef);

      Map<String, dynamic> docData =
          documentSnapshot.data() as Map<String, dynamic>;

      // Compute new number of ratings
      int newNumRatings = docData['ratingCount'] + 1;

      double oldRatingTotal =
          docData['exactRating'].toDouble() * docData['ratingCount'];
      double newAvgRating = (oldRatingTotal + data['rating']) / newNumRatings;
      // Compute new average rating

      // Update restaurant info
      transaction.update(restaurantRef, {
        'exactRating': newAvgRating,
        'rating': double.parse(newAvgRating.toStringAsFixed(1)),
        'ratingCount': newNumRatings,
      });

      transaction.update(getStatsReviewDocumentReference(restaurantId), {
        'total$statsfinalString': FieldValue.increment(1),
        subjectStats: FieldValue.increment(1),
      });
      transaction.set(getReviewCollectionReference(restaurantId).doc(), data);
    });
  }

  Future reportReview(Review review) async {
    String? userId = auth.FirebaseAuth.instance.currentUser?.uid;

    await getReviewDocumentReference(review.restaurantId!, review.id!)
        .collection('reports')
        .add({"review_id": review.id, "reporterId": userId});
  }

  Future reportComment(Review comment) async {
    String? userId = auth.FirebaseAuth.instance.currentUser?.uid;
    await getReviewDocumentReference(comment.restaurantId!, comment.id!)
        .collection('comments')
        .doc(comment.id)
        .collection('reports')
        .add({"review_id": comment.id, "reporterId": userId});
  }

  Future editReview(String? restaurantId, String? reviewId, Map data,
      double oldRating) async {
    DocumentReference restaurantRef =
        db.collection('restaurants').doc(restaurantId);
    await db.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot = await transaction.get(restaurantRef);
      Map<String, dynamic> docData =
          documentSnapshot.data() as Map<String, dynamic>;

      int ratingCount = docData['ratingCount'];
      double oldRatingTotal = docData['exactRating'].toDouble() * ratingCount;
      double newAvgRating =
          (oldRatingTotal + data['rating'] - oldRating) / ratingCount;
      transaction
          .update(getReviewCollectionReference(restaurantId!).doc(reviewId), {
        ...data,
      });
      transaction.update(restaurantRef, {
        'exactRating': newAvgRating,
        'rating': double.parse(newAvgRating.toStringAsFixed(1)),
      });
    });
    // await getReviewCollectionReference(restaurantId).doc(reviewId).update({
    //   ...data,
    // });
  }

  Future deleteComment(
      Review comment, String restaurantId, String reviewId) async {
    String commentId = comment.id!;

    WriteBatch batch = db.batch();

    batch.delete(getReviewResponseCollectionReference(restaurantId, reviewId)
        .doc(commentId));

    batch.update(getReviewDocumentReference(restaurantId, reviewId), {
      'commentsCount': FieldValue.increment(-1),
    });

    try {
      batch.commit();
    } catch (e) {}
  }

  Future editReviewsRespond(
      Review review, String commentId, String comment) async {
    String restaurantId = review.restaurantId!;
    String reviewId = review.id!;

    getReviewResponseCollectionReference(restaurantId, reviewId)
        .doc(commentId)
        .update({
      'comment': comment,
      'updateAt': FieldValue.serverTimestamp(),
    });
  }

  Future addReviewsRespond(Review review, String comment) async {
    User user = authenticationService.currentUser!;
    String restaurandId = review.restaurantId!;
    String reviewId = review.id!;
    Map<String, dynamic> data = {
      'userId': user.id,
      'userImageProfileUrl': user.userProfileUrl,
      'comment': comment,
      'userName': user.username,
      'createdAt': FieldValue.serverTimestamp(),
      'updateAt': FieldValue.serverTimestamp(),
    };
    WriteBatch batch = db.batch();

    batch.set(
        getReviewResponseCollectionReference(restaurandId, reviewId).doc(),
        data);

    batch.update(getReviewDocumentReference(restaurandId, reviewId), {
      'commentsCount': FieldValue.increment(1),
    });

    try {
      batch.commit();
    } catch (e) {}
  }

  Future likeReview(Review review, bool state) async {
    int incrementValue = state ? -1 : 1;

    WriteBatch batch = db.batch();

    batch.set(getUserLikeDocumentRef(review.id!), {
      'state': !state,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(
        getReviewCollectionReference(review.restaurantId!).doc(review.id), {
      'likesCounts': FieldValue.increment(incrementValue),
    });

    //mettre a jour les statistque des j'aime au niveau des revue

    try {
      batch.commit();
    } catch (e) {}
  }

  Future deleteReview(Review review) async {
    String restaurantId = review.restaurantId!;
    String reviewId = review.id!;
    String subject = review.subject!;
    String subjectStats = getReviewSubjectStringForStats(subject);

    int incrementValue = -1;

    CollectionReference responceReviewCollection =
        getReviewResponseCollectionReference(restaurantId, reviewId);

    try {
      DocumentReference restaurantRef =
          db.collection('restaurants').doc(restaurantId);

      await db.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(restaurantRef);

        Map<String, dynamic> docData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Compute new number of ratings
        int newNumRatings = docData['ratingCount'] + incrementValue;

        double newAvgRating;
        if (newNumRatings == 0) {
          newNumRatings = 0;
          newAvgRating = 0;
        } else {
          // Compute new average rating
          double oldRatingTotal =
              docData['exactRating'].toDouble() * docData['ratingCount'];
          newAvgRating = (oldRatingTotal - review.rating!) / newNumRatings;
        }

        // Update restaurant info
        transaction.update(restaurantRef, {
          'exactRating': newAvgRating,
          'rating': double.parse(newAvgRating.toStringAsFixed(1)),
          'ratingCount': newNumRatings,
        });

        QuerySnapshot querySnapshot = await responceReviewCollection.get();
        querySnapshot.docs.forEach((doc) {
          transaction.delete(doc.reference);
        });

        transaction.delete(getReviewDocumentReference(restaurantId, reviewId));

        transaction.update(getStatsReviewDocumentReference(restaurantId), {
          'total$statsfinalString': FieldValue.increment(incrementValue),
          subjectStats: FieldValue.increment(incrementValue),
        });
      });

      await _uploadService.deleteMultiImages(review.imagesLinks!);
    } catch (e) {
      print('une erreur s\'est produite $e');
    }
  }

  Future deleteReviewPhoto(Review review, String photoUrl) async {
    try {
      // await FirebaseStorage.instance.ref(photoUrl).delete();

      await getReviewDocumentReference(review.restaurantId!, review.id!)
          .update({
        "imagesLinks": FieldValue.arrayRemove([photoUrl]),
      });
      await _uploadService.deleteImage(photoUrl);
    } catch (e) {
      print('ereur : $e');
    }
  }

  Future getReviewsByRestaurantId(String id, String? filter) async {
    try {
      var reviewsDocumentsSnapshot;

      if (filter != null) {
        reviewsDocumentsSnapshot = await getReviewCollectionReference(id)
            .where('subject', isEqualTo: filter)
            .orderBy('createdAt', descending: true)
            .get();
      } else {
        reviewsDocumentsSnapshot = await getReviewCollectionReference(id)
            .orderBy('createdAt', descending: true)
            .get();
      }

      if (reviewsDocumentsSnapshot.docs.isNotEmpty) {
        return List<Review>.from(reviewsDocumentsSnapshot.docs.map((snapshot) {
          var data = snapshot.data();

          return Review.serializeImage(data, snapshot.id);
        }).toList());
      } else {
        return List<Review>.from([]);
      }
    } catch (e) {
      if (e is PlatformException) {
        print('error: $e');
        return e.message;
      }
      print('error: ${e.toString()}');

      return e.toString();
    }
  }
}
