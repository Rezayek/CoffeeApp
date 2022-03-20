import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/auth/auth_service.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_Firedatabase_model.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_database_constants.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_database_exception.dart';

class CartFireDatabase {
  static final _shared = CartFireDatabase._sharedInstance();
  CartFireDatabase._sharedInstance();
  factory CartFireDatabase() => _shared;
  dynamic _cartFire;

  void creatCollection({required String userId}) {
    _cartFire = FirebaseFirestore.instance.collection(userId);
  }

  String get cart => _cartFire.toString();

  Future<void> createCartItems({
    required String itemId,
    required String userId,
    required String itemName,
    required String itemPrize,
    required String itemQte,
  }) async {
    try {
      _cartFire.add({
        itemIdCartFire: itemId,
        userIdCartFire: userId,
        itemNameCartFire: itemName,
        itemPrizeCartFire: itemPrize,
        itemQteCartFire: itemQte,
      });
    } catch (e) {
      throw FailedToSendCart();
    }
  }

  Future<Iterable<CartFireDatabaseModel>> getCartItem() async {
    log(_cartFire.toString());
    final test = await _cartFire.get().then((value) =>
        value.docs.map((doc) => CartFireDatabaseModel.fromsnapshot(doc)));

    log(test.toList());
    return test;
  }
}
