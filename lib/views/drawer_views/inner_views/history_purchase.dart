import 'dart:developer';

import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/auth_service.dart';
import 'package:coffee_app/services/cart_local_database/cart_database_model.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_Firedatabase_model.dart';
import 'package:coffee_app/services/firebase_database_cart/cart_fire_database.dart';
import 'package:flutter/material.dart';

class HistoryPurchases extends StatefulWidget {
  HistoryPurchases({Key? key}) : super(key: key);

  @override
  State<HistoryPurchases> createState() => _HistoryPurchasesState();
}

class _HistoryPurchasesState extends State<HistoryPurchases> {
  final CartFireDatabase _purchaseItems = CartFireDatabase();
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  Widget build(BuildContext context) {
    _purchaseItems.creatCollection(userId: userId);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: irishCoffeeColor.withOpacity(0.6),
          title: const Text(
            'History purchases',
            style: TextStyle(
                color: coffeeCakeColor,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          )),
      body: Container(
        decoration: BoxDecoration(
          color: irishCoffeeColor.withOpacity(0.7),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'Item name',
                  style: TextStyle(color: coffeeCakeColor, fontSize: 20),
                ),
                Text(
                  'Item prize',
                  style: TextStyle(color: coffeeCakeColor, fontSize: 20),
                ),
                Text(
                  'Item Qte',
                  style: TextStyle(color: coffeeCakeColor, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: _purchaseItems.getCartItem(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.done:
                      log('here :'+_purchaseItems.cart);

                      if (snapshot.hasData) {
                        final purchases =
                            snapshot.data as Iterable<CartFireDatabaseModel>;

                        return SizedBox(
                          height: 600,
                          width: 380,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: purchases.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        purchases.elementAt(index).itemName,
                                        style: const TextStyle(
                                            color: coffeeCakeColor,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        purchases.elementAt(index).itemPrize,
                                        style: const TextStyle(
                                            color: coffeeCakeColor,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        purchases.elementAt(index).itemQte,
                                        style: const TextStyle(
                                            color: coffeeCakeColor,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Container();
                      }

                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                })
          ],
        ),
      ),
    );
  }
}
