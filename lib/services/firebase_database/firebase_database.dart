import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/services/firebase_database/categorie_item_model.dart';
import 'package:coffee_app/services/firebase_database/categorie_item_model_constants.dart';
import 'package:coffee_app/services/firebase_database/firebase_database_exception.dart';

class FirebaseDatabase {
  final categories = FirebaseFirestore.instance.collection('items');

  static final _shared = FirebaseDatabase._sharedInstance();
  FirebaseDatabase._sharedInstance();
  factory FirebaseDatabase() => _shared;

  Future<Iterable<CategorieItemModel>> getItemsData() async {
    try {
      return await categories.get().then((value) =>
          value.docs.map((doc) => CategorieItemModel.fromSnapShot(doc)));
    } catch (e) {
      throw CategorieItemNotFound();
    }
  }

  Future<Iterable<CategorieItemModel>> getBestSellingData(
      {required bool bestOrNot}) async {
    try {
      return await categories
          .where(bestSellingFire, isEqualTo: bestOrNot)
          .get()
          .then((value) =>
              value.docs.map((doc) => CategorieItemModel.fromSnapShot(doc)));
    } catch (e) {
      throw CategorieItemNotFound();
    }
  }

  Future<Iterable<CategorieItemModel>> getCategorieItemsData(
      {required String categorie}) async {
    try {
      return await categories
          .where(itemCategorieFire, isEqualTo: categorie)
          .get()
          .then((value) =>
              value.docs.map((doc) => CategorieItemModel.fromSnapShot(doc)));
    } catch (e) {
      throw CategorieItemNotFound();
    }
  }

  Future<Iterable<String>> getDocsId() async {
    final snapshot = await FirebaseFirestore.instance.collection('items').get();
    return snapshot.docs.map(
      (e) {
        return e.id;
      },
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getItemData({required String itemId}) async {
    try {
      return await categories.doc(itemId).get();
      
    } catch (e) {
      throw CategorieItemNotFound();
    }
  }
}
