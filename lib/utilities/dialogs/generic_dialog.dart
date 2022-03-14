import 'package:coffee_app/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DialogOptions<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptions optionBuilder,
}) {
  final option = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        
        backgroundColor: coffeeCakeColor.withOpacity(0.8),
        title: Text(title, style: const TextStyle(color: blackCoffeeColor, fontSize: 20, fontWeight: FontWeight.w600),),
        content: Text(content, style: const TextStyle(color: blackCoffeeColor, fontSize: 18, fontWeight: FontWeight.w400),),
        actions: option.keys.map((optionTitle) {
          final T value = option[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle, style: const TextStyle(color: blackCoffeeColor, fontSize: 18, fontWeight: FontWeight.w400),));
        }).toList(),
      );
    },
  );
}
