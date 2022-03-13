import 'package:coffee_app/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An Error has occurred',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}
