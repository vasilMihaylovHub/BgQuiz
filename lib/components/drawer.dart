import 'package:flutter/material.dart';
import 'package:quiz_maker/views/profile.dart';
import 'package:quiz_maker/views/ranking.dart';

import '../common/functions.dart';
import '../services/auth_service.dart';
import '../views/signin.dart';

class MyDrawer extends StatefulWidget {


  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [DrawerHeader(child: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.inversePrimary,
            )),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("Н А Ч А Л О"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("П Р О Ф И Л"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.shield,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("К Л А С А Ц И Я"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RankingPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text("О Т П И Ш И"),
              onTap: () {
                logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    authService.signOut().then((val) {
      LocalStore.saveCurrentUser(isLoggedIn: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    });
  }
}
