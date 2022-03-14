import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUserData {
  final String userDataId;
  final String userId;
  final String userFirstName;
  final String userSecondName;
  final String userEmail;
  final String userAddress;
  final String userPhone;
  final String userCoupons;

  const AuthUserData({
    required this.userDataId,
    required this.userId,
    required this.userFirstName,
    required this.userSecondName,
    required this.userEmail,
    required this.userAddress,
    required this.userPhone,
    required this.userCoupons,
  });

  AuthUserData.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userDataId = snapshot.id,
        userId = snapshot.data()[userOwnId],
        userFirstName = snapshot.data()[firstName],
        userSecondName = snapshot.data()[secondName],
        userEmail = snapshot.data()[email],
        userAddress = snapshot.data()[address],
        userPhone = snapshot.data()[phone],
        userCoupons = snapshot.data()[coupons];


}
