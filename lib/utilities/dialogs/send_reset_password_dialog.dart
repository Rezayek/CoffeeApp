import 'package:coffee_app/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showSendResetPasswordDialog({
  required BuildContext context,
}) {
  return showGenericDialog(
      context: context,
      title: 'Check your email',
      content: 'A reset password email has been sent',
      optionBuilder: () => {'Ok': null});
}
