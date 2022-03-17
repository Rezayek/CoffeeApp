import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_model_constants.dart';

class ReviewModel {
  final String reviewId;
  final String reviewUserId;
  final String reviewItemId;
  final String reviewDate;
  final String reviewContent;
  final String reviewUserRate;
  final String reviewUserName;

  ReviewModel({
    required this.reviewId,
    required this.reviewUserId,
    required this.reviewItemId,
    required this.reviewDate,
    required this.reviewContent,
    required this.reviewUserRate,
    required this.reviewUserName,
  });
  ReviewModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : reviewId = snapshot.id,
        reviewUserId = snapshot.data()[reviewUserIdFire],
        reviewItemId = snapshot.data()[reviewItemIdFire],
        reviewDate = snapshot.data()[reviewDataFire],
        reviewContent = snapshot.data()[reviewContentFire],
        reviewUserRate = snapshot.data()[reviewUserRatingFire],
        reviewUserName = snapshot.data()[reviewUserNameFire];
}
