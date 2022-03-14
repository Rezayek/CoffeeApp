import 'package:coffee_app/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showManageAccountDialog({required BuildContext context}) {
  return showGenericDialog(
      context: context,
      title: 'Changing user infos',
      content: 'Are you sure about changing your data ?',
      optionBuilder: () => {'No': false, 'Yes': true}).then(
    (value) => value ,
  );
}
