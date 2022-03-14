import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';

import 'package:coffee_app/views/app_main_views/navigation_Ui/navigation_view.dart';
import 'package:coffee_app/views/user_views/forget_password_view.dart';
import 'package:coffee_app/views/user_views/login_view.dart';
import 'package:coffee_app/views/user_views/register_view.dart';
import 'package:coffee_app/views/user_views/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppController extends StatelessWidget {
  const AppController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return LoginView();
        } else if (state is AuthStateRegistering) {
          return RegisterView();
        } else if (state is AuthStateLoggedIn) {
          return  MainNavigationView();
        } else if (state is AuthStateNeedsVerification) {
          return VerificationView();
        } else if (state is AuthStateForgotPassword) {
          return ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
