import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth/bloc/auth_bloc.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            }
          },
          child: Text('log out'),
        ),
      ),
    );
  }
}
