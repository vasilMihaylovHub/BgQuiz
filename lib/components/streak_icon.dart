import 'package:flutter/material.dart';
import 'package:quiz_maker/services/points_service.dart';
import 'package:quiz_maker/services/user_service.dart';
import '../views/profile.dart';

class StreakIconButton extends StatelessWidget {
  const StreakIconButton({super.key});

  Future<Map<String, dynamic>> _loadStreak() async {
    try {
      var user = await UserService().getUserDetails();
      List<String> streakDays = List<String>.from(user['streakDays'] ?? []);
      bool activeToday = PointsService.isActiveToday(streakDays);
      int counter = PointsService.calculateCurrantStreak(streakDays);
      return {'activeToday': activeToday, 'counter': counter};
    } catch (e) {
      print('Error loading streak: $e');
      return {'activeToday': false, 'counter': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadStreak(),
      builder: (context, snapshot) {

        var data = snapshot.data;
        bool activeToday = data?['activeToday'] ?? false;
        int counter = data?['counter'] ?? 0;

        return IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.star,
                size: 40,
                color: activeToday ? Colors.yellow : Colors.grey,
              ),
              if (counter > 0) _buildCounterBadge(counter),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterBadge(int counter) {
    return Positioned(
      right: -5,
      top: -5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(
          maxWidth: 20,
        ),
        child: Center(
          child: Text(
            counter.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}