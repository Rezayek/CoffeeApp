import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/services/auth/firebase_auth_provider.dart';
import 'package:coffee_app/views/app_main_views/main_view.dart';
import 'package:coffee_app/views/user_views/login_view.dart';
import 'package:coffee_app/views/user_views/register_view.dart';
import 'package:coffee_app/views/user_views/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create:  ((context) => AuthBloc(FirebaseAuthProvider())),
        child: const AppController(),
      ),
    );
  }
}

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
          return const MainView();
        } else if (state is AuthStateNeedsVerification) {
          return VerificationView();
        }  else {
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
