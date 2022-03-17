import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/constants/storage_folders_name.dart';
import 'package:coffee_app/handle_firestorage_pictures/firebase_storage_get_pictures.dart';
import 'package:coffee_app/services/firebase_database/categorie_item_model_constants.dart';
import 'package:coffee_app/services/firebase_database/firebase_database.dart';
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
  final String itemId;
  FirebaseDatabase itemData = FirebaseDatabase();
  FirebaseStorageGetPictures itemImage =
      FirebaseStorageGetPictures(folderName: categorieFolderName);

  _ItemViewState({required this.itemId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brownCoffeeColor.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          width: double.maxFinite,
          decoration: BoxDecoration(color: brownCoffeeColor.withOpacity(0.7)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 600,
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
                          final requiredData = snapshot.data as DocumentSnapshot;
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
                                      folderPhotoName: realData[photoFolderFire]),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      case ConnectionState.done:
                                        if (snapshot.hasData) {
                                          final imgUrl = snapshot.data as String;
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
                                const SizedBox(height: 35,),
                                Container(
                                  width:260 ,
                                  height: 200,
                                  decoration: BoxDecoration(color: irishCoffeeColor.withOpacity(0.8),borderRadius: BorderRadius.circular(26)),
                                  child: Row(
                                    children: [                                   
                                      Container(
                                        height: 190,
                                        width: 175,
                                        padding: const EdgeInsets.all(20),
                                        
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Categorie: '+realData[itemCategorieFire], style: const TextStyle(color: coffeeCakeColor, fontSize: 18),),
                                            const SizedBox(height: 10,),
                                            Text('Prize: '+realData[itemPrizeFire], style: const TextStyle(color: coffeeCakeColor, fontSize: 18),),
                                            const SizedBox(height: 10,),
                                            SizedBox(
                                              width: 120,
                                              height: 25,
                                              child: Row(
                                                children: [
                                                const Text('Rating: ', style: TextStyle(color: coffeeCakeColor, fontSize: 18),),
                                                const Icon(Icons.star, color: Color.fromARGB(255, 255, 217, 0),size: 18,),
                                                Text(realData[itemRatingFire], style: const TextStyle(color: coffeeCakeColor, fontSize: 18), )
                                              ]),
                                            ),
                                            const SizedBox(height: 10,),
                                            Text('Countrie: '+realData[itemCountrieFire], style: const TextStyle(color: coffeeCakeColor, fontSize: 18),)
                                
                                          ],
                                        ) ,
                                      ),
                                      AddBtn(),
                                    ],
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
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingBtn(),
    );
  }
}
