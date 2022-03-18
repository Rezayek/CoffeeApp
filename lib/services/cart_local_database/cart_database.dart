import 'dart:async';
import 'dart:developer';

import 'package:coffee_app/services/cart_local_database/cart_database_constants.dart';
import 'package:coffee_app/services/cart_local_database/cart_database_exception.dart';
import 'package:coffee_app/services/cart_local_database/cart_database_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class CartDatabase {
  Database? _db;

  List<CartDatabaseModel> _cartItems = [];

  static final CartDatabase _shared = CartDatabase._sharedInstance();

  CartDatabase._sharedInstance() {
    _cartStreamController =
        StreamController<List<CartDatabaseModel>>.broadcast(onListen: () {
      _cartStreamController.sink.add(_cartItems);
    });
  }

  factory CartDatabase() => _shared;

  late final StreamController<List<CartDatabaseModel>> _cartStreamController;

  Stream<List<CartDatabaseModel>> cart() {
    _cacheItems();
    return _cartStreamController.stream;
  }

  Future<void> _cacheItems() async {
    final allNotes = await getAllItems();
    _cartItems = allNotes.toList();
    _cartStreamController.add(_cartItems);
  }

  Future<void> updateItem(
      {required String itemId,
      required int itemCost,
      required int itemStock}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(
        cartTable, {itemCostColumn: itemCost, itemStockColumn: itemStock},
        where: 'itemId = ?', whereArgs: [itemId]);

    if (updateCount == 0) {
      throw CouldNotUpdateCartException();
    } else {
      final updatedItem = await getItem(itemId: itemId);
      _cartItems.removeWhere((element) => element.itemId == itemId);
      _cartItems.add(updatedItem);
      _cartStreamController.add(_cartItems);
    }
  }

  Future<CartDatabaseModel> getItem({required String itemId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db
        .query(cartTable, limit: 1, where: 'id = ?', whereArgs: [itemId]);

    if (results.isEmpty) {
      throw CouldNotFoundItemException();
    } else {
      final item = CartDatabaseModel.fromRow(results.first);
      //remove the old note in cache to put the new one
      _cartItems.removeWhere((item) => item.itemId == itemId);
      _cartItems.add(item);
      _cartStreamController.add(_cartItems);

      return item;
    }
  }

  Future<Iterable<CartDatabaseModel>> getAllItems() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await db.query(cartTable);
    return items.map((item) => CartDatabaseModel.fromRow(item));
  }

  Future<int> deleteAllItems() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numbreOfDeletions = await db.delete(cartTable);
    _cartItems = [];
    _cartStreamController.add(_cartItems);
    return numbreOfDeletions;
  }

  Future<void> deleteCartItem({required String itemId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(cartTable, where: 'itemId = ?', whereArgs: [itemId]);

    if (deletedCount == 0) {
      throw CouldNotDeleteItemException();
    } else {
      _cartItems.removeWhere((element) => element.itemId == itemId);
      _cartStreamController.add(_cartItems);
    }
  }

  Future<void> createCartItem({
    required String userId,
    required String itemId,
    required String itemName,
    required int itemCost,
    required int itemStock,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    try {
      await db.insert(cartTable, {
        userIdColumn: userId,
        itemIdColumn: itemId,
        itemNameColumn: itemName,
        itemCostColumn: itemCost,
        itemStockColumn: itemStock
      });
    } catch (e) {
      throw ItemAleardyAdded();
    }
    log('item added');

    // final cartItem = CartDatabaseModel(
    //     userId: userId,
    //     itemId: itemId,
    //     itemName: itemName,
    //     itemCost: itemCost,
    //     itemStock: itemStock);
    // _cartItems.add(cartItem);
    // _cartStreamController.add(_cartItems);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createCartTable);
      await _cacheItems();
    } catch (e) {
      throw UnableToCreatCartException();
    }
  }
}
