import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_exceptions.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_model.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_model_constants.dart';

class ReviewsDatabase {
  final reviews = FirebaseFirestore.instance.collection('reviews');

  static final _shared = ReviewsDatabase._sharedInstance();
  ReviewsDatabase._sharedInstance();
  factory ReviewsDatabase() => _shared;

  Future<void> creatReview({
    required String reviewUserId,
    required String reviewItemId,
    required String reviewDate,
    required String reviewContent,
    required String reviewUserRate,
    required String reviewUserName,
  }) async {
    try {
      await reviews.add({
        reviewUserIdFire: reviewUserId,
        reviewItemIdFire: reviewItemId,
        reviewDataFire: reviewDate,
        reviewUserRatingFire: reviewUserRate,
        reviewContentFire: reviewContent,
        reviewUserNameFire: reviewUserName,
      });
    } catch (e) {
      throw FailedToAddReview();
    }
  }

  Future<Iterable<ReviewModel>> getReviews({required String itemId}) async {
    // return  await  reviews.snapshots().map((event) => event.docs
    //     .map((doc) => ReviewModel.fromSnapshot(doc))
    //     .where((review) => review.reviewItemId == itemId));

    return await reviews.where(reviewItemIdFire, isEqualTo: itemId).get().then((value) =>
              value.docs.map((doc) => ReviewModel.fromSnapshot(doc)));
    
  }
}
