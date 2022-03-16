import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/views/app_main_views/sub_views/categorie_view.dart';
import 'package:flutter/material.dart';

class CategorieRow extends StatefulWidget {
  final List<String> categories, categorieNames, categorieNavHepler;
  const CategorieRow({Key? key, required this.categories, required this.categorieNames, required this.categorieNavHepler}) : super(key: key);

  @override
  State<CategorieRow> createState() =>
      _CategorieRowState(categories: this.categories, categorieNames: this.categorieNames, categorieNavHepler: this.categorieNavHepler);
}

class _CategorieRowState extends State<CategorieRow> {
  final List<String> categories, categorieNames, categorieNavHepler;

  _CategorieRowState({required this.categories, required this.categorieNames, required this.categorieNavHepler});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(), 
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategorieView(categorieName: categorieNavHepler[index]) ));
              },
              child: Container(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(categorieNames[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: blackCoffeeColor))
                  ],
                ) ,
              ),
            );
          }),
    );
  }
}
