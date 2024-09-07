import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/main.dart';
import 'package:quiz_maker/services/points_service.dart';
import 'package:quiz_maker/services/user_service.dart';

import '../components/app_bar.dart';
import '../services/asset_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService userService = UserService();
  AssetService assetService = AssetService();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Профил'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: userService.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          Map<String, dynamic>? user = snapshot.data?.data();
          _imagePath = user?['imageUrl'];
          bool hasProfilePicture = _imagePath != null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Section
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: hasProfilePicture ? NetworkImage(_imagePath!) : null,
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: hasProfilePicture
                                      ? null
                                      : const Icon(Icons.person, size: 64, color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                MyTextField(
                                  text: user?['name'] ?? 'Not Set',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                MyTextField(
                                  text: user?['email'] ?? 'not@set',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _showEditModal(context, user);
                                  },
                                  icon: Icon(Icons.edit),
                                  label: MyTextField(text: 'Edit Profile'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Ranking Info Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTextField(
                                text: 'Points: ${user?['points'] ?? 0}',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 8),
                              MyTextField(
                                text: 'Streak: ${getStreakCount(user)}',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showInviteFriendModal(context);
                        },
                        icon: Icon(Icons.mail_outline),
                        label: MyTextField(text: 'Invite a Friend'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  void _showInviteFriendModal(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invite a Friend'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Enter friend\'s email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: MyTextField(text: 'Cancel',),
            ),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                if (email.isNotEmpty) {
                  _sendInvitation(email);
                  Navigator.of(context).pop();
                }
              },
              child: const MyTextField(text: 'Send Invitation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                )
            ),
          ],
        );
      },
    );
  }

  void _sendInvitation(String email) {
    logger.w('User try to invite a friend: $email');
    //TODO Implement when the app is hosted
  }

  int getStreakCount(Map<String, dynamic>? user){
    return  PointsService.calculateCurrantStreak(List<String>.from(user?['streakDays'] ?? []));
  }

  void _showEditModal(BuildContext context, Map<String, dynamic>? user) {
    TextEditingController nameController = TextEditingController(text: user?['name']);
    File? newImage;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const MyTextField(text: 'Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    newImage = File(pickedFile.path);
                    setState(() {});
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: (newImage != null
                      ? FileImage(newImage!)
                      : _imagePath != null && _imagePath!.isNotEmpty
                        ? NetworkImage( _imagePath!)
                        : null) as ImageProvider?,
                  child: _imagePath == null
                      ? const Icon(Icons.person, size: 64, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newImage != null) {
                  String imageUrl = await assetService.uploadImage(newImage!);
                  await userService.updateUserProfile(nameController.text, imageUrl);
                } else {
                  await userService.updateUserName(nameController.text);
                }
                Navigator.of(context).pop();
                setState(() {
                });
              },
              child: const Text('Save'),

            ),
          ],
        );
      },
    );
  }
}
