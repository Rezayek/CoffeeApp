import 'package:coffee_app/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';


Future<bool> showSubmitDialog({required BuildContext context}) {
  return showGenericDialog(
      context: context,
      title: 'App using conditions',
      content:'''1- condition-1\t\n 2- condition-2''',
      optionBuilder: ()=>{'I agree': true, 'Disagree' : false}).then((value) => value ?? false);
}
