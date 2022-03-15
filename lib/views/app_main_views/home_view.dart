// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:ui';

import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/constants/storage_folders_name.dart';
import 'package:coffee_app/handle_firestorage_pictures/firebase_storage_get_pictures.dart';
import 'package:coffee_app/services/firebase_database/categorie_item_model.dart';
import 'package:coffee_app/services/firebase_database/firebase_database.dart';
import 'package:coffee_app/views/app_main_views/navigation_Ui/navigation_view.dart';
import 'package:coffee_app/views/widgets/categorie_row.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseStorageGetPictures storagePictures =
      FirebaseStorageGetPictures(folderName: offersFolderName);
  FirebaseDatabase itemsData = FirebaseDatabase();

  List<List<String>> categories = [['assets/beens_categorie.jpg','assets/machines_categorie.jpg'], ['assets/products_categorie.jpg','assets/cups_design_categorie.jpg'], ['assets/recepies_categorie.jpg',]];
  List<List<String>> categoriesNames = [['Coffee Beens','Coffee Machines'], ['Coffee Products','Coffee Cups'], ['Coffee Recepies',]];
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
            child: SingleChildScrollView(
              child: SizedBox(
                height: 1250,
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Latest offers',
                        style: TextStyle(
                          color: blackCoffeeColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 230,
                      width: double.maxFinite,
                      child: FutureBuilder(
                          future: storagePictures.listFiles(),
                          builder:
                              (context, AsyncSnapshot<ListResult> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final offersFileNames =
                                      snapshot.data as ListResult;
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: offersFileNames.items.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 12,
                                          right: 12,
                                        ),
                                        child: ClipRRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: Container(
                                              width: 310,
                                              height: 230,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                child: FutureBuilder(
                                                    future: storagePictures
                                                        .downloarUrl(
                                                            offersFileNames
                                                                .items[index]
                                                                .name),
                                                    builder:
                                                        (context, snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .waiting:
                                                          return Center(
                                                            child: SizedBox(
                                                                width: 80,
                                                                height: 80,
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          );

                                                        case ConnectionState
                                                            .done:
                                                          if (snapshot
                                                              .hasData) {
                                                            final offerImgUrl =
                                                                snapshot.data
                                                                    as String;
                                                            log(offerImgUrl);
                                                            return InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                height: 190,
                                                                width: 290,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        offerImgUrl),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              MainNavigationView()),
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .replay_outlined)),
                                                            );
                                                          }
                                                        default:
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 80,
                                                              height: 80,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                } else {
                                  return Center(
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MainNavigationView()),
                                          );
                                        },
                                        icon: Icon(Icons.replay_outlined)),
                                  );
                                }
                              default:
                                return Center(
                                  child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CircularProgressIndicator()),
                                );
                            }
                          }),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Best selling',
                        style: TextStyle(
                          color: blackCoffeeColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: itemsData.getBestSellingData(bestOrNot: true),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(),
                              ),
                            );

                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final bestSellingItems =
                                  snapshot.data as Iterable<CategorieItemModel>;
                              return SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: bestSellingItems.length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                          future: storagePictures
                                              .downloarUrlOfItem(
                                                  imageName: bestSellingItems
                                                      .elementAt(index)
                                                      .photoName,
                                                  folderPhotoName:
                                                      bestSellingItems
                                                          .elementAt(index)
                                                          .photoFolder),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Center(
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 80,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              case ConnectionState.done:
                                                if (snapshot.hasData) {
                                                  final imgUrl =
                                                      snapshot.data as String;
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Container(
                                                          height: 180,
                                                          width: 310,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                blackCoffeeColor
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        36),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                height: 160,
                                                                width: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              36),
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          imgUrl),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 210,
                                                                width: 140,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      bestSellingItems
                                                                          .elementAt(
                                                                              index)
                                                                          .itemName,
                                                                      style: TextStyle(
                                                                          color:
                                                                              coffeeCakeColor,
                                                                          fontSize:
                                                                              25,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      'Categorie: ' +
                                                                          bestSellingItems
                                                                              .elementAt(index)
                                                                              .itemCategorie,
                                                                      style: TextStyle(
                                                                          color:
                                                                              coffeeCakeColor,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      'Prize: ' +
                                                                          bestSellingItems
                                                                              .elementAt(index)
                                                                              .itemPrize,
                                                                      style: TextStyle(
                                                                          color:
                                                                              coffeeCakeColor,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          115,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            'Rating:',
                                                                            style: TextStyle(
                                                                                color: coffeeCakeColor,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Icon(
                                                                            Icons.star,
                                                                            size:
                                                                                18,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                208,
                                                                                0),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            bestSellingItems.elementAt(index).itemRating,
                                                                            style: TextStyle(
                                                                                color: coffeeCakeColor,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w400),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  MainNavigationView(),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(Icons
                                                            .replay_outlined)),
                                                  );
                                                }

                                              default:
                                                return Center(
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 80,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                            }
                                          });
                                    }),
                              );
                            } else {
                              return Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MainNavigationView(),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.replay_outlined)),
                              );
                            }

                          default:
                            return Center(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(),
                              ),
                            );
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          top: 25),
                      height: 650,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: oldCoffeeColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                              children: [
                                const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                color: blackCoffeeColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Container(
                            height: 550,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return CategorieRow(
                                      categories: categories[index],
                                      categorieNames: categoriesNames[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
