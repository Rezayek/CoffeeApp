import 'package:coffee_app/services/cart_local_database/cart_database_constants.dart';

class CartDatabaseModel {
  final String userId;
  final String itemId;
  final String itemName;
  final int itemCost;
  final int itemStock;

  CartDatabaseModel({
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.itemCost,
    required this.itemStock,
  });

  CartDatabaseModel.fromRow(Map<String, Object?> map)
      : userId = map[userIdColumn] as String,
        itemId = map[itemIdColumn] as String,
        itemName = map[itemNameColumn] as String,
        itemCost = map[itemCostColumn] as int,
        itemStock = map[itemStockColumn] as int;
}
