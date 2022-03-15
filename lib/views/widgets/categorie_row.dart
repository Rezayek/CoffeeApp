import 'package:coffee_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CategorieRow extends StatefulWidget {
  final List<String> categories, categorieNames;
  CategorieRow({Key? key, required this.categories, required this.categorieNames}) : super(key: key);

  @override
  State<CategorieRow> createState() =>
      _CategorieRowState(categories: this.categories, categorieNames: this.categorieNames);
}

class _CategorieRowState extends State<CategorieRow> {
  final List<String> categories, categorieNames;

  _CategorieRowState({required this.categories, required this.categorieNames});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        physics: ClampingScrollPhysics(), 
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              width: 155,
              height: 225,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.only(top: 10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 155,
                    width: 145,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(categories[index]),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [BoxShadow(blurRadius: 8,spreadRadius: 5,color: blackCoffeeColor.withOpacity(0.8))]
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(categorieNames[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: blackCoffeeColor))
                ],
              ) ,
            );
          }),
    );
  }
}
