const String dbName = "useercart.db";
const String cartTable = "cart";
const String userIdColumn = "userId";
const String itemIdColumn = "itemId";
const String itemNameColumn = "itemName";
const String itemCostColumn = "itemCost";
const String itemStockColumn = "itemStock";

const String createCartTable = '''
            CREATE TABLE IF NOT EXISTS "cart"(
              "userId"  TEXT NOT NULL,
              "itemId" TEXT NOT NULL,
              "itemName" TEXT NOT NULL,
              "itemCost" INTEGER NOT NULL,
              "itemStock" INTEGER NOT NULL,
              PRIMARY KEY("itemId")
            );''';
