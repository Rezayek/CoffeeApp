import 'package:coffee_app/constants/appTexts/login_texts.dart';
import 'package:coffee_app/constants/appTexts/register_texts.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/auth_exception.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong email or password');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'indentified Error try again');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/picture-2.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              height: 360,
              width: 350,
              decoration: BoxDecoration(
                color: brownCoffeeColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(36),
                border:
                    Border.all(color: blackCoffeeColor.withBlue(26), width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 12, left: 12, right: 12, bottom: 20),
                      child: Text(
                        welcomeText,
                        style: TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: coffeeCakeColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: enterEmailText,
                        hintStyle: TextStyle(
                          color: coffeeCakeColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: coffeeCakeColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                      autocorrect: false,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: enterEmailText,
                        hintStyle: TextStyle(
                          color: coffeeCakeColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthEventLogIn(
                                  _emailController.text,
                                  _passwordController.text));
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Container(
                              width: 110,
                              height: 70,
                              decoration: BoxDecoration(
                                color: brownCoffeeColor.withOpacity(0.8),
                                border: Border.all(
                                  color: irishCoffeeColor.withRed(120),
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: coffeeCakeColor.withOpacity(0.6),
                                    blurRadius: 7,
                                    spreadRadius: 4,
                                  )
                                ],
                              ),
                              child: const Center(
                                  child: Text(
                                loginTextBtn,
                                style: TextStyle(
                                  color: coffeeCakeColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventShouldRegister());
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Container(
                              width: 110,
                              height: 70,
                              decoration: BoxDecoration(
                                color: brownCoffeeColor.withOpacity(0.8),
                                border: Border.all(
                                  color: irishCoffeeColor.withRed(120),
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: coffeeCakeColor.withOpacity(0.6),
                                    blurRadius: 7,
                                    spreadRadius: 4,
                                  )
                                ],
                              ),
                              child: const Center(
                                  child: Text(
                                registerTextBtn,
                                style: TextStyle(
                                  color: coffeeCakeColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: Row(
                        children: [
                          const Text(
                            forgetPasswordText,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if(_emailController.text != null){
                                context
                                  .read<AuthBloc>()
                                  .add(AuthEventForgotPassword(email: _emailController.text,));
                              }else{
                                context
                                  .read<AuthBloc>()
                                  .add(AuthEventForgotPassword());
                              }
                              
                            },
                            child: const Text(
                              clicKHereText,
                              style: TextStyle(
                                color: Color.fromARGB(255, 38, 154, 248),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
