import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_database_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartFireDatabaseModel {
  final String purchaseId;
  final String itemId;
  final String userId;
  final String itemName;
  final String itemPrize;
  final String itemQte;

  const CartFireDatabaseModel({
    required this.purchaseId,
    required this.itemId,
    required this.userId,
    required this.itemName,
    required this.itemPrize,
    required this.itemQte,
  });

  CartFireDatabaseModel.fromsnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : purchaseId = snapshot.id,
        itemId = snapshot[itemIdCartFire],
        userId = snapshot[userIdCartFire],
        itemName = snapshot[itemNameCartFire],
        itemPrize = snapshot[itemPrizeCartFire],
        itemQte = snapshot[itemQteCartFire];
}
