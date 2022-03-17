import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        child: Material(
                          color: Colors.white.withOpacity(0),
                          shadowColor: blackCoffeeColor,
                          elevation: 15,
                          child: TextField(
                            controller: _searchController,
                            autocorrect: true,
                            cursorHeight: 17,
                            maxLength: 35,
                            style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w400,),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Search...',
                              fillColor: arabicCoffeeColor.withOpacity(0.6),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: blackCoffeeColor),
                                borderRadius: BorderRadius.circular(25.7),

                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: blackCoffeeColor),
                          child: const Icon(
                            Icons.search,
                            color: coffeeCakeColor,
                            size: 30,
                            
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
