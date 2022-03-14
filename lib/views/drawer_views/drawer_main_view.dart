import 'package:coffee_app/constants/colors.dart';
import 'package:coffee_app/services/auth/auth_service.dart';
import 'package:coffee_app/services/auth/bloc/auth_bloc.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data.dart';
import 'package:coffee_app/services/auth/cloud_user/firabase_user_cloud_storage.dart';
import 'package:coffee_app/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerMainView extends StatefulWidget {
  DrawerMainView({Key? key}) : super(key: key);

  @override
  State<DrawerMainView> createState() => _DrawerMainViewState();
}

class _DrawerMainViewState extends State<DrawerMainView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseUserCloudStorage _userData = FirebaseUserCloudStorage();
  late final Iterable<AuthUserData> userInfo;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blackCoffeeColor.withOpacity(0.9),
      child: FutureBuilder(
          future: _userData.getUserData(userAcountId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final userInfo = snapshot.data as Iterable<AuthUserData>;
                  return ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          userInfo.elementAt(0).userFirstName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: coffeeCakeColor,
                          ),
                        ),
                        accountEmail: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userInfo.elementAt(0).userEmail,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: coffeeCakeColor),
                            ),
                            Text(
                              'Coupons: ' + userInfo.elementAt(0).userCoupons,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: coffeeCakeColor),
                            )
                          ],
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/picture-10.jpg',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'Manage your account',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Modify your account Data',
                            style: TextStyle(
                              color: coffeeCakeColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.credit_card_rounded,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'Add credit card info',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'you will not see your credit card infos',
                            style: TextStyle(
                              color: coffeeCakeColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'History',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Purchases history',
                            style: TextStyle(
                              color: coffeeCakeColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'Settings',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'App Settings',
                            style: TextStyle(
                              color: coffeeCakeColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.feedback_rounded,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'Contact us',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: coffeeCakeColor,
                          size: 23,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: coffeeCakeColor,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          final shouldLogOut = await showLogOutDialog(context);
                          if (shouldLogOut) {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.replay_outlined),
                    ),
                  );
                }

              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
                return Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.replay_outlined),
                  ),
                );
            }
          }),
    );
  }
}