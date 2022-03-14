import 'dart:math';

import 'package:coffee_app/constants/appTexts/register_texts.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/auth_exception.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:coffee_app/utilities/dialogs/submit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  late final TextEditingController _userFirstNameController;
  late final TextEditingController _userSecondNameController;
  late final TextEditingController _userEmailController;
  late final TextEditingController _userPasswordController;
  late final TextEditingController _userAdresseController;
  late final TextEditingController _userPhoneController;

  @override
  void initState() {
    _userFirstNameController = TextEditingController();
    _userSecondNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    _userAdresseController = TextEditingController();
    _userPhoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userFirstNameController.dispose();
    _userSecondNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userAdresseController.dispose();
    _userPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlearyInUseAuthException) {
            await showErrorDialog(context, 'Email is already used');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'please check your given infos');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: coffeeCakeColor,
                ),
              ),
              const Text(registerText),
            ],
          ),
          backgroundColor: brownCoffeeColor,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/picture-6.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              height: 530,
              width: 350,
              decoration: BoxDecoration(
                color: brownCoffeeColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(36),
                border:
                    Border.all(color: blackCoffeeColor.withBlue(26), width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 12, left: 12, right: 12, bottom: 20),
                        child: Text(
                          registerText,
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _userFirstNameController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: userFirstNameText,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _userSecondNameController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: userSecondNameText,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _userEmailController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: userEmailText,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _userPasswordController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        obscureText: true,
                        enableSuggestions: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          hintText: userPasswordText,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _userAdresseController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: userAdressText,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _userPhoneController,
                        style: const TextStyle(
                          color: coffeeCakeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: userPhoneNumber,
                          hintStyle: TextStyle(
                            color: coffeeCakeColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              userContionsText,
                              style: TextStyle(
                                fontSize: 14,
                                color: coffeeCakeColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final agreed =
                                      await showSubmitDialog(context: context);
                                  if (agreed) {
                                    setState(() {
                                      _isChecked = true;
                                    });
                                  } else{
                                    setState(() {
                                      _isChecked = false;
                                    });
                                  }
                              },
                              child: const Text(
                                userClickHere,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 109, 183, 243),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_isChecked) {
                                  context.read<AuthBloc>().add(
                                        AuthEventRegister(
                                          _userEmailController.text,
                                          _userPasswordController.text,
                                          _userFirstNameController.text,
                                          _userSecondNameController.text,
                                          _userAdresseController.text,
                                          _userPhoneController.text,
                                        ),
                                      );
                                } else {
                                  await showErrorDialog(
                                      context, 'check the user contidion');
                                }
                              } else {
                                await showErrorDialog(
                                    context, 'Fill all labels please');
                              }
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
                                registerText,
                                style: TextStyle(
                                  color: coffeeCakeColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
