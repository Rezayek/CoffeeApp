import 'package:coffee_app/app_controller.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/firebase_auth_provider.dart';
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
      title: 'My Coffee',
      
      home: BlocProvider<AuthBloc>(
        create: ((context) => AuthBloc(FirebaseAuthProvider())),
        child: const AppController(),
      ),
    );
  }
}

