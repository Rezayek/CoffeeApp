import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/constants/storage_folders_name.dart';
import 'package:coffee_app/handle_firestorage_pictures/firebase_storage_get_pictures.dart';
import 'package:coffee_app/services/cart_local_database/cart_database.dart';
import 'package:coffee_app/services/cart_local_database/cart_database_exception.dart';
import 'package:coffee_app/services/cart_local_database/cart_database_model.dart';
import 'package:coffee_app/services/firebase_database_items/categorie_item_model.dart';
import 'package:coffee_app/services/firebase_database_items/categorie_item_model_constants.dart';
import 'package:coffee_app/services/firebase_database_items/firebase_database.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late final FirebaseDatabase _item;
  late final FirebaseStorageGetPictures _itemImage;
  late final CartDatabase _cartItems;
  @override
  void initState() {
    _item = FirebaseDatabase();
    _itemImage = FirebaseStorageGetPictures(folderName: categorieFolderName);
    _cartItems = CartDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    coffeeCakeColor.withOpacity(0.9),
                    blackCoffeeColor.withOpacity(0.9),
                    coffeeCakeColor.withOpacity(0.9),
                  ],
                  begin: const Alignment(-0.4, 15),
                  end: const Alignment(3, -2),
                ),
              ),
            ),
          ),
          Positioned(
              child: Container(
            height: 600,
            child: StreamBuilder(
              stream: _cartItems.cart(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final items =
                          snapshot.data as Iterable<CartDatabaseModel>;
                      return Container(
                        height: 650,
                        
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Scrollbar(
                              child: SizedBox(
                                  height: 500,
                                  width: 380,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          height: 105,
                                          width: 350,
                                          decoration: BoxDecoration(
                                              color: irishCoffeeColor
                                                  .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(26)),
                                          child: Row(
                                            children: [
                                              FutureBuilder(
                                                  future: _item.getItemData(
                                                      itemId: items
                                                          .elementAt(index)
                                                          .itemId),
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState.none:
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      case ConnectionState
                                                          .waiting:
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );

                                                      case ConnectionState.done:
                                                        if (snapshot.hasData) {
                                                          final requiredData =
                                                              snapshot.data
                                                                  as DocumentSnapshot;
                                                          final realData =
                                                              requiredData
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>;

                                                          return FutureBuilder(
                                                              future: _itemImage.downloarUrlOfItem(
                                                                  imageName:
                                                                      realData[
                                                                          photoNameFire],
                                                                  folderPhotoName:
                                                                      realData[
                                                                          photoFolderFire]),
                                                              builder: (context,
                                                                  snapshot) {
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .done:
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      final imgUrl =
                                                                          snapshot.data
                                                                              as String;
                                                                      return Container(
                                                                        height:
                                                                            105,
                                                                        width:
                                                                            100,
                                                                        decoration: BoxDecoration(
                                                                            image:
                                                                                DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.fill),
                                                                            borderRadius: BorderRadius.circular(26)),
                                                                      );
                                                                    } else {
                                                                      return Container(
                                                                        height:
                                                                            105,
                                                                        width:
                                                                            100,
                                                                        decoration: BoxDecoration(
                                                                            image:
                                                                                const DecorationImage(image: AssetImage('assets/default.jpg'), fit: BoxFit.fill),
                                                                            borderRadius: BorderRadius.circular(26)),
                                                                      );
                                                                    }

                                                                  default:
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                }
                                                              });
                                                        } else {
                                                          return Container(
                                                            height: 105,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                image: const DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/default.jpg'),
                                                                    fit: BoxFit
                                                                        .fill),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            26)),
                                                          );
                                                        }

                                                      default:
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                    }
                                                  }),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 10,
                                                    left: 15),
                                                child: SizedBox(
                                                  height: 105,
                                                  width: 165,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        items
                                                            .elementAt(index)
                                                            .itemName,
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                blackCoffeeColor),
                                                      ),
                                                      Text(
                                                        'Prize: ' +
                                                            items
                                                                .elementAt(
                                                                    index)
                                                                .itemCost
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                blackCoffeeColor),
                                                      ),
                                                      Text(
                                                        'Qte: ' +
                                                            items
                                                                .elementAt(
                                                                    index)
                                                                .itemStock
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                blackCoffeeColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        await _cartItems
                                                            .deleteCartItem(
                                                                itemId: items
                                                                    .elementAt(
                                                                        index)
                                                                    .itemId);
                                                      } on CouldNotDeleteItemException catch (_) {
                                                        showErrorDialog(context,
                                                            'Failed to delete try again');
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .remove_circle_outline_rounded,
                                                      color: Colors.redAccent,
                                                      size: 40,
                                                    )),
                                              )
                                            ],
                                          ),
                                        );
                                      })),
                            ),
                            Container(
                              height: 100,
                              width: 280,
                              child: items.length > 0? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                                      ),
                                    onPressed: () {},
                                    child: const SizedBox(
                                      height: 50,
                                      width: 90,
                                      child: Center(
                                        child: Text(
                                          'Buy',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 245, 50, 50)),
                                      ),
                                    onPressed: () async {
                                      try {
                                        await _cartItems.deleteAllItems();
                                      } catch (e) {
                                        showErrorDialog(context, 'try again');
                                      }
                                    },
                                    child: const SizedBox(
                                      height: 50,
                                      width: 90, 
                                      child: Center(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ): Container(),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                  default:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
            ),
          ))
        ],
      ),
    );
  }
}
