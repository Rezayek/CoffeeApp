import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/constants/storage_folders_name.dart';
import 'package:coffee_app/handle_firestorage_pictures/firebase_storage_get_pictures.dart';
import 'package:coffee_app/services/auth/auth_service.dart';
import 'package:coffee_app/services/auth/cloud_user/firabase_user_cloud_storage.dart';
import 'package:coffee_app/services/firebase_database_items/categorie_item_model_constants.dart';
import 'package:coffee_app/services/firebase_database_items/firebase_database.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_exceptions.dart';
import 'package:coffee_app/services/firebase_database_reviews/review_model.dart';
import 'package:coffee_app/services/firebase_database_reviews/reviews_database.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:coffee_app/utilities/dialogs/manage_review.dart';
import 'package:coffee_app/views/widgets/addBtn.dart';
import 'package:coffee_app/views/widgets/floating_btn.dart';
import 'package:flutter/material.dart';

class ItemView extends StatefulWidget {
  final String itemId;
  ItemView({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState(itemId: itemId);
}

class _ItemViewState extends State<ItemView> {
  late final TextEditingController _reviewController;
  String get _userId => AuthService.firebase().currentUser!.id;
  final FirebaseUserCloudStorage _user = FirebaseUserCloudStorage();
  final ReviewsDatabase _reviews = ReviewsDatabase();
  String currentRate = "Rate";
  List<String> ratingList = [
    "Rate",
    "1-Star",
    "2-Stars",
    "3-Stars",
    "4-Stars",
    "5-Stars",
  ];
  final String itemId;
  FirebaseDatabase itemData = FirebaseDatabase();
  FirebaseStorageGetPictures itemImage =
      FirebaseStorageGetPictures(folderName: categorieFolderName);

  _ItemViewState({required this.itemId});
  @override
  void initState() {
    _reviewController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brownCoffeeColor.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1500,
          width: double.maxFinite,
          decoration: BoxDecoration(color: brownCoffeeColor.withOpacity(0.7)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 680,
                child: FutureBuilder(
                  future: itemData.getItemData(itemId: itemId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: IconButton(
                            icon: const Icon(Icons.replay),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemView(
                                    itemId: itemId,
                                  ),
                                ),
                              ).then((value) => setState(() {}));
                            },
                          ),
                        );

                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final requiredData =
                              snapshot.data as DocumentSnapshot;
                          final realData =
                              requiredData.data() as Map<String, dynamic>;

                          return SizedBox(
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    realData[itemNameFire],
                                    style: const TextStyle(
                                        color: brownCoffeeColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                FutureBuilder(
                                  future: itemImage.downloarUrlOfItem(
                                      imageName: realData[photoNameFire],
                                      folderPhotoName:
                                          realData[photoFolderFire]),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      case ConnectionState.done:
                                        if (snapshot.hasData) {
                                          final imgUrl =
                                              snapshot.data as String;
                                          return Container(
                                            height: 155,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(imgUrl),
                                                    fit: BoxFit.fill),
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                          );
                                        } else {
                                          return Container(
                                            height: 155,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/default.jpg'),
                                                    fit: BoxFit.fill),
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                          );
                                        }

                                      default:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Container(
                                  width: 260,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      color: irishCoffeeColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 220,
                                        width: 175,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Categorie: ' +
                                                  realData[itemCategorieFire],
                                              style: const TextStyle(
                                                  color: coffeeCakeColor,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Prize: ' +
                                                  realData[itemPrizeFire],
                                              style: const TextStyle(
                                                  color: coffeeCakeColor,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 120,
                                              height: 25,
                                              child: Row(children: [
                                                const Text(
                                                  'Rating: ',
                                                  style: TextStyle(
                                                      color: coffeeCakeColor,
                                                      fontSize: 18),
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Color.fromARGB(
                                                      255, 255, 217, 0),
                                                  size: 18,
                                                ),
                                                Text(
                                                  realData[itemRatingFire],
                                                  style: const TextStyle(
                                                      color: coffeeCakeColor,
                                                      fontSize: 18),
                                                )
                                              ]),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Countrie: ' +
                                                  realData[itemCountrieFire],
                                              style: const TextStyle(
                                                  color: coffeeCakeColor,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'On stock:  ',
                                                    style: TextStyle(
                                                        color: coffeeCakeColor,
                                                        fontSize: 18),
                                                  ),
                                                  Icon(
                                                      realData[itemStockFire] ==
                                                              true
                                                          ? Icons.check
                                                          : Icons
                                                              .not_interested,
                                                      color: realData[
                                                                  itemStockFire] ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      AddBtn(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 330,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: coffeeCakeColor,
                                      borderRadius: BorderRadius.circular(26)),
                                  child: Text(
                                    realData[itemDescriptionFire],
                                    style: const TextStyle(
                                        color: blackCoffeeColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.replay),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemView(
                                      itemId: itemId,
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                            ),
                          );
                        }

                      default:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                ),
              ),
              Container(
                height: 260,
                width: 360,
                margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave a review',
                      style: TextStyle(
                          color: blackCoffeeColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: coffeeCakeColor.withOpacity(0.7),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: orangeCoffeeColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                      controller: _reviewController,
                      autocorrect: true,
                      maxLength: 200,
                      maxLines: 4,
                      style: TextStyle(fontSize: 18, color: blackCoffeeColor),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton(
                              value: currentRate,
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: coffeeCakeColor,
                                size: 22,
                              ),
                              iconSize: 20,
                              elevation: 16,
                              items: List.generate(
                                  ratingList.length,
                                  (index) => DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(ratingList[index]),
                                            ],
                                          ),
                                        ),
                                        value: ratingList[index],
                                      )),
                              onChanged: (value) => setState(() {
                                    currentRate = value.toString();
                                  })),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_reviewController.text.length >= 20) {
                                if (currentRate != 'Rate') {
                                  final user = await _user.getUserData(
                                      userAcountId: _userId);

                                  try {
                                    await _reviews.creatReview(
                                        reviewUserId: _userId,
                                        reviewItemId: itemId,
                                        reviewDate: DateTime.now().toString(),
                                        reviewContent: _reviewController.text,
                                        reviewUserRate: currentRate,
                                        reviewUserName: user
                                                .elementAt(0)
                                                .userFirstName +
                                            ' ' +
                                            user.elementAt(0).userSecondName);
                                    _reviewController.text = '';
                                  } on FailedToAddReview catch (_) {
                                    await showErrorDialog(context, 'failed to save review');
                                  }
                                } else {
                                  await showManageReview(
                                      context: context,
                                      text: 'Select a rating');
                                }
                              } else {
                                await showManageReview(
                                    context: context,
                                    text: 'At least 20 caracter');
                              }
                            },
                            child: const Text("Post"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FutureBuilder(
                  future: _reviews.getReviews(itemId: itemId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ItemView(itemId: itemId))))
                                    .then((value) => setState(() {}));
                              },
                              icon: const Icon(
                                Icons.replay,
                                size: 25,
                              )),
                        );

                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final dataReviews =
                              snapshot.data as Iterable<ReviewModel>;
                          return SizedBox(
                            height: 450,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Reviews',
                                    style: TextStyle(
                                        color: blackCoffeeColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  height: 15,
                                ),
                                Scrollbar(
                                  child: SizedBox(
                                    height: 400,
                                    child: ListView.builder(
                                        itemCount: dataReviews.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: 200,
                                            width: 350,
                                            margin: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 320,
                                                  height: 35,
                                                  child: Row(
                                                    children: [
                                                      const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/coffeeAvatar.jpg')),
                                                      Text(
                                                        dataReviews
                                                            .elementAt(index)
                                                            .reviewUserName,
                                                        style: const TextStyle(
                                                            color:
                                                                coffeeCakeColor,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        dataReviews
                                                            .elementAt(index)
                                                            .reviewUserRate,
                                                        style: const TextStyle(
                                                            color:
                                                                coffeeCakeColor,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      // const SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      // Text(
                                                      //   dataReviews
                                                      //       .elementAt(index)
                                                      //       .reviewDate,
                                                      //   style: const TextStyle(
                                                      //       color: coffeeCakeColor,
                                                      //       fontSize: 10,
                                                      //       fontWeight:
                                                      //           FontWeight.w500),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 150,
                                                  width: 340,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      color: irishCoffeeColor
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              26)),
                                                  child: Text(
                                                    dataReviews
                                                        .elementAt(index)
                                                        .reviewContent,
                                                    style: const TextStyle(
                                                        color: coffeeCakeColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ItemView(itemId: itemId))))
                                      .then((value) => setState(() {}));
                                },
                                icon: const Icon(
                                  Icons.replay,
                                  size: 25,
                                )),
                          );
                        }
                      default:
                        return Center(
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ItemView(itemId: itemId))))
                                    .then((value) => setState(() {}));
                              },
                              icon: const Icon(
                                Icons.replay,
                                size: 25,
                              )),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingBtn(),
    );
  }
}
