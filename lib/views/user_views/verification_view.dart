import 'package:coffee_app/constants/appTexts/verification_texts.dart';
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationView extends StatefulWidget {
  VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
            const Text(
              'Acount Verification',
              style: TextStyle(
                color: coffeeCakeColor,
              ),
            ),
          ],
        ),
        backgroundColor: brownCoffeeColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/picture-8.jpg'), fit: BoxFit.fill),
        ),
        child: Center(
          child: Container(
            height: 330,
            width: 300,
            padding: const EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: coffeeCakeColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  verificationNotice,
                  style: TextStyle(
                    color: oldCoffeeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      didNotrecieveText,
                      style: TextStyle(
                        color: oldCoffeeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                      },
                      child: const Text(
                        resendText,
                        style: TextStyle(
                          color: Color.fromARGB(255, 69, 165, 243),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: Center(
                    child: Container(
                        height: 75,
                        width: 100,
                        decoration: BoxDecoration(
                            color: orangeCoffeeColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                spreadRadius: 6,
                                color: blackCoffeeColor.withOpacity(0.8),
                              ),
                            ]),
                        child: const Center(
                          child: Text(
                            backLoginText,
                            style: TextStyle(
                              color: coffeeCakeColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
