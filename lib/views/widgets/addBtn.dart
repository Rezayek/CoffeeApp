import 'package:coffee_app/constants/colors.dart';
import 'package:flutter/material.dart';

class AddBtn extends StatelessWidget {
  const AddBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        width: 70,
        height: 40,
        decoration:BoxDecoration(
          color: coffeeCakeColor,
          borderRadius: BorderRadius.circular(46),
    
        ) ,
        child: Row(
          children: const [
            Icon(Icons.add, color: brownCoffeeColor, size: 20,),
            SizedBox(width: 5,),
            Text('Add ', style: TextStyle(color: brownCoffeeColor, fontSize: 18, fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}