import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/constants/storage_folders_name.dart';
import 'package:coffee_app/handle_firestorage_pictures/firebase_storage_get_pictures.dart';
import 'package:coffee_app/services/firebase_database/categorie_item_model.dart';
import 'package:coffee_app/services/firebase_database/firebase_database.dart';
import 'package:coffee_app/views/widgets/addBtn.dart';
import 'package:flutter/material.dart';

class CategorieView extends StatefulWidget {
  final String categorieName;
  const CategorieView({Key? key, required this.categorieName})
      : super(key: key);

  @override

  // ignore: no_logic_in_create_state
  State<CategorieView> createState() =>
      _CategorieViewState(categorieName: categorieName);
}

class _CategorieViewState extends State<CategorieView> {
  final String categorieName;

  final FirebaseDatabase _categoriesList = FirebaseDatabase();
  final FirebaseStorageGetPictures _categorieImages =
      FirebaseStorageGetPictures(folderName: categorieFolderName);

  _CategorieViewState({required this.categorieName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: irishCoffeeColor.withOpacity(0.8),
        title: Text(
          categorieName.toUpperCase(),
          style: const TextStyle(
              color: coffeeCakeColor,
              fontSize: 23,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height  ,

        decoration: BoxDecoration(color: brownCoffeeColor.withOpacity(0.7)),
        child: Scrollbar(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future:
                _categoriesList.getCategorieItemsData(categorie: categorieName),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: IconButton(
                      icon: const Icon(Icons.replay_10_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategorieView(
                                    categorieName: categorieName,
                                  )),
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
                    final categorieItems =
                        snapshot.data as Iterable<CategorieItemModel>;
                    return ListView.builder(
                      itemCount: categorieItems.length,
                      itemBuilder: ((context, index) {
                      
                      return Container(
                        height: 170,
                        width: 300,
                        decoration: BoxDecoration(
                            color: blackCoffeeColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(26)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              
                              children: [
                                FutureBuilder(
                                    future: _categorieImages.downloarUrlOfItem(
                                        imageName: categorieItems
                                            .elementAt(index)
                                            .photoName,
                                        folderPhotoName: categorieItems
                                            .elementAt(index)
                                            .photoFolder),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case ConnectionState.done:
                                          if (snapshot.hasData) {
                                            final imageUrl =
                                                snapshot.data as String;
                                            return Container(
                                              height:155 ,
                                              width:120 ,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(26)
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              height:155 ,
                                              width:120 ,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(image: AssetImage('assets/default.jpg'), fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(26)
                                              ),
                                            );
                                          }
                                        default:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                      }
                                    }),
                                SizedBox(
                                  width:160 ,
                                  height: 155,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only( top: 8.0, bottom: 10.0),
                                        child: Text(categorieItems.elementAt(index).itemName, style: const TextStyle(color: coffeeCakeColor, fontSize: 23, fontWeight: FontWeight.w500),),
                                      ),
                                      SizedBox(
                                        height: 25,
                                        child: Row(
                                          
                                          children: [
                                            const SizedBox(width: 28,),
                                            const Text('Rating: ', style: TextStyle(color: coffeeCakeColor, fontSize: 18, fontWeight: FontWeight.w400),),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.star, color: Color.fromARGB(255, 243, 228, 23), size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(categorieItems.elementAt(index).itemRating, style: const TextStyle(color: coffeeCakeColor, fontSize: 18, fontWeight: FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text('Prize: '+categorieItems.elementAt(index).itemPrize, style: const TextStyle(color: coffeeCakeColor, fontSize: 18, fontWeight: FontWeight.w400),),
                                      const SizedBox(height: 5,),
                                      Text('Countrie: '+categorieItems.elementAt(index).itemCountrie, style: const TextStyle(color: coffeeCakeColor, fontSize: 18, fontWeight: FontWeight.w400),),
                                      
                                    ],
                                  ),
                                )    
                                ,const AddBtn()
                                ]),
                        ),
                      );
                    }));
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
        )),
      ),
    );
  }
}
