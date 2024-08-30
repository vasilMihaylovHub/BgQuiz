import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function onTab;
  AuthService authService = AuthService();


  SquareTile({super.key,
  required this.imagePath, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Image.asset(
          imagePath,
          height: 45,
        ),
      ),
    );
  }
}
