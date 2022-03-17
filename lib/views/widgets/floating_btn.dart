import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/views/app_main_views/navigation_Ui/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingBtn extends StatelessWidget {
  FloatingBtn({Key? key}) : super(key: key);
  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: SpeedDial(
          animatedIcon: AnimatedIcons.list_view,
          backgroundColor: arabicCoffeeColor.withOpacity(0.6),
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          openCloseDial: isDialOpen,
          spacing: 10,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.home),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainNavigationView(
                              currentIndex: 0,
                            )));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.shopping_bag),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainNavigationView(
                              currentIndex: 1,
                            )));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.search),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainNavigationView(
                              currentIndex: 2,
                            )));
              },
            ),
          ],
        ),
      );
  }
}