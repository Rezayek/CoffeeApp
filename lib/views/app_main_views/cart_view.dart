import 'package:coffee_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center,
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
      ],),
    );
  }
}