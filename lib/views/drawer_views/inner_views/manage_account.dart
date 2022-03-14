
import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data.dart';
import 'package:coffee_app/services/auth/cloud_user/cloud_user_exceptions.dart';
import 'package:coffee_app/services/auth/cloud_user/firabase_user_cloud_storage.dart';
import 'package:coffee_app/utilities/dialogs/error_dialog.dart';
import 'package:coffee_app/utilities/dialogs/manage_account_dialog.dart';

import 'package:flutter/material.dart';



class ManageAccountView extends StatefulWidget {
  final String userId;
  final String userDataId;

  // ignore: prefer_const_constructors_in_immutables
  ManageAccountView({Key? key, required this.userId, required this.userDataId}) : super(key: key);

  @override
  State<ManageAccountView> createState() =>
      // ignore: no_logic_in_create_state
      _ManageAccountViewState(userId: userId, userDataId:  userDataId);
}

class _ManageAccountViewState extends State<ManageAccountView> {
  final String userId;
  final String userDataId;
  late final Iterable<AuthUserData> userData;

  final _formKey = GlobalKey<FormState>();
  _ManageAccountViewState({required this.userId, required this.userDataId});
  final FirebaseUserCloudStorage _userData = FirebaseUserCloudStorage();

  late final TextEditingController _userFirstName;
  late final TextEditingController _userSecondName;
  late final TextEditingController _userAddress;
  late final TextEditingController _userPhone;

  late final List<TextEditingController> controllerList = [
    _userFirstName,
    _userSecondName,
    _userAddress,
    _userPhone,
  ];
  final List<String> labelText = [
    'User first name',
    'User second name',
    'User Adsress',
    'User Phone,'
  ];
  void asignControllers(Iterable<AuthUserData> userData) {
    _userFirstName.text = userData.elementAt(0).userFirstName;
    _userSecondName.text = userData.elementAt(0).userSecondName;
    _userAddress.text = userData.elementAt(0).userAddress;
    _userPhone.text = userData.elementAt(0).userPhone;
  }

  @override
  void initState() {
    _userFirstName = TextEditingController();
    _userSecondName = TextEditingController();
    _userAddress = TextEditingController();
    _userPhone = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _userAddress.dispose();
    _userFirstName.dispose();
    _userAddress.dispose();
    _userPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: brownCoffeeColor.withOpacity(0.8),
        title: Row(
          children: const [
            SizedBox(
              width: 7,
            ),
            Text(
              'Manage Account',
              style: TextStyle(
                color: coffeeCakeColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                  image: AssetImage('assets/picture-4.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: irishCoffeeColor.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 480,
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: FutureBuilder(
                          future: _userData.getUserData(userAcountId: userId),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final userData =
                                      snapshot.data as Iterable<AuthUserData>;
                                  asignControllers(userData);
                                  return SizedBox(
                                    height: 400,
                                    width: 250,
                                    child: Form(
                                      key: _formKey,
                                      child: ListView.builder(
                                        itemCount: controllerList.length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 80,
                                            width: 250,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 10,
                                              ),
                                              child: TextFormField(
                                                autocorrect: false,
                                                controller:
                                                    controllerList[index],
                                                decoration: InputDecoration(
                                                  labelText: labelText[index],
                                                  labelStyle: const TextStyle(
                                                    color: coffeeCakeColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 23,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              default:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                            }
                          }),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final changeData =
                              await showManageAccountDialog(context: context);
                          if (changeData == true) {
                            try {
                              await _userData.updateUserData(
                                userDataId: userDataId,
                                userFirstName: _userFirstName.text,
                                userSecondName: _userSecondName.text,
                                userAddress: _userAddress.text,
                                userPhone: _userPhone.text,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageAccountView(
                                      userId: userId, userDataId: userDataId,),
                                ),
                              );
                            } on CouldNotUpdateUserDataEception catch (_) {
                              showErrorDialog(context,
                                  'could not update the data try again');
                            }
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(blackCoffeeColor)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: blackCoffeeColor,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
