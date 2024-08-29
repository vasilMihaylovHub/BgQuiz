import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/services/user_service.dart';

class ProfilePage extends StatelessWidget {
  UserService userService = UserService();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .colorScheme
              .inversePrimary, //change your color here
        ),
        title: Center(
          child: Text(
            'Profile',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: userService.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          }
          Map<String, dynamic>? user = snapshot.data?.data();

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  text: user?['name'],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                MyTextField(
                  text: user?['email'],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
