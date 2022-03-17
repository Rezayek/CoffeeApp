import 'package:coffee_app/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showManageReview(
    {required BuildContext context, required String text}) {
  return showGenericDialog(
      context: context,
      title: 'Reminder',
      content: text,
      optionBuilder: () => {'OK': null});
}
