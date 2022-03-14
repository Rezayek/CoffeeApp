import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/views/app_main_views/cart_view.dart';
import 'package:coffee_app/views/app_main_views/home_view.dart';
import 'package:coffee_app/views/app_main_views/search_view.dart';
import 'package:coffee_app/views/drawer_views/drawer_main_view.dart';
import 'package:flutter/material.dart';


class MainNavigationView extends StatefulWidget {
  MainNavigationView({Key? key}) : super(key: key);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  List views = [
    HomeView(),
    CartView(),
    SearchView(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brownCoffeeColor.withOpacity(0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              currentIndex == 0
                  ? Icons.home
                  : currentIndex == 1
                      ? Icons.shopping_bag
                      : Icons.search,
              color: blackCoffeeColor,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "My Coffee",
              style: TextStyle(
                color: coffeeCakeColor,
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: views[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: brownCoffeeColor.withOpacity(0.8),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: blackCoffeeColor,
        unselectedItemColor: coffeeCakeColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              label: "home_view",
              icon: Icon(
                Icons.home,
                size: 35,
              )),
          BottomNavigationBarItem(
              label: "cart_view", icon: Icon(Icons.shopping_bag, size: 35,)),
          BottomNavigationBarItem(
              label: "search_view", icon: Icon(Icons.search, size: 35,))
        ],
      ),
      drawer: DrawerMainView(),
    );
  }
}
