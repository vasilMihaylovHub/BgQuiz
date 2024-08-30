import 'package:flutter/material.dart';
import '../views/profile.dart';

class StreakIconButton extends StatelessWidget {
  final int streakDays= 7; //load streak

  const StreakIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          // The base icon
          const Icon(
            Icons.star, // Replace with your desired icon
            size: 40,
          ),
          // The badge with streak days
          if (streakDays > 0)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: BoxConstraints(
                  maxWidth: 20,
                ),
                child: Center(
                  child: Text(
                    streakDays.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
    );
  }
}
