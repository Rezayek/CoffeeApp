import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/auth_exception.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:coffee_app/utilities/dialogs/send_reset_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _toEmailController;

  @override
  void initState() {
    _toEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _toEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'An Error has occurred try again');
          } else if (state.hasSentEmail == true) {
            await showSendResetPasswordDialog(context: context);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: coldBrewCoffeeColor,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: coffeeCakeColor,
                  )),
              const Text(
                'Reset password',
                style: TextStyle(color: coffeeCakeColor),
              )
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                  decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/picture-9.jpg'),
                    fit: BoxFit.fill),
              )),
            ),
            Positioned(
              top: 90,
              child: Center(
                child: Container(
                  width: 300,
                  height: 320,
                  decoration: BoxDecoration(
                      color: orangeCoffeeColor.withOpacity(0.4),
                      border: Border.all(
                        color: arabicCoffeeColor.withOpacity(0.7),
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Enter your Account email Address',
                          style: TextStyle(
                              color: blackCoffeeColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, bottom: 20, right: 5),
                          child: TextField(
                            controller: _toEmailController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                hintText: 'Account Email',
                                hintStyle: TextStyle(
                                  color: blackCoffeeColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                AuthEventForgotPassword(
                                    email: _toEmailController.text));
                          },
                          child: Container(
                            height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                              color: irishCoffeeColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 3,
                                  color: blackCoffeeColor,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                    color: coffeeCakeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
