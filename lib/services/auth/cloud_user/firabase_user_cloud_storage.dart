import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data_constants.dart';
import 'package:coffee_app/services/auth/cloud_user/cloud_user_exceptions.dart';

class FirebaseUserCloudStorage {
  final users = FirebaseFirestore.instance.collection('users');

  //signleton-------------------------------------------

  static final _shared = FirebaseUserCloudStorage._sharedInstance();
  FirebaseUserCloudStorage._sharedInstance();
  factory FirebaseUserCloudStorage() => _shared;
  //----------------------------------------------------

  Future<void> creatNewUserData({
    required String userId,
    required String userFirstName,
    required String userSecondName,
    required String userEmail,
    required String userPhone,
    required String userAddress,
  }) async {
    final document = await users.add({
      userOwnId: userId,
      firstName: userFirstName,
      secondName: userSecondName,
      address: userAddress,
      email: userEmail,
      phone: userPhone,
    });
  }

  Future<Iterable<AuthUserData>> getUserData(
      {required String userAcountId}) async {
    try {
      return await users
          .where(
            userOwnId,
            isEqualTo: userAcountId,
          )
          .get()
          .then((value) =>
              value.docs.map((doc) => AuthUserData.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotFoundUserDataException();
    }
  }
}
