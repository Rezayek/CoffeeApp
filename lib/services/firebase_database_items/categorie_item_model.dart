import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/firebase_database_items/categorie_item_model_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CategorieItemModel {
  final String itemId;
  final String itemName;
  final String photoFolder;
  final String photoName;
  final String itemCategorie;
  final bool bestSelling;
  final String itemPrize;
  final String itemRating;
  final String itemCountrie;
  final bool itemStock;
  final String itemDescription;

  const CategorieItemModel(
      {required this.itemId,
      required this.itemName,
      required this.photoFolder,
      required this.photoName,
      required this.itemCategorie,
      required this.bestSelling,
      required this.itemPrize,
      required this.itemRating,
      required this.itemCountrie,
      required this.itemStock,
      required this.itemDescription,
      });

  CategorieItemModel.fromSnapShot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : itemId = snapshot.id,
        itemName = snapshot.data()[itemNameFire],
        photoFolder = snapshot.data()[photoFolderFire],
        photoName = snapshot.data()[photoNameFire],
        itemCategorie = snapshot.data()[itemCategorieFire],
        bestSelling = snapshot.data()[bestSellingFire],
        itemPrize = snapshot.data()[itemPrizeFire],
        itemRating = snapshot.data()[itemRatingFire],
        itemCountrie = snapshot.data()[itemCountrieFire],
        itemStock = snapshot.data()[itemStockFire],
        itemDescription = snapshot.data()[itemDescriptionFire];
}
