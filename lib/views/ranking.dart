import 'package:flutter/material.dart';
import 'package:quiz_maker/components/app_bar.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/services/user_service.dart';

class RankingPage extends StatelessWidget {
  final UserService userService = UserService();

  RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Класация'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: userService.getUsersRanked(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final rank = index + 1;
              final name = user['name'];
              final points = user['points'];
              final List<String> streakDays = List<String>.from(user['streakDays'] ?? []);
              final imageUrl = user['imageUrl'];
              final hasProfilePicture = imageUrl != null;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: _buildMedalOrRank(rank),
                    title: MyTextField(text: name,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: MyTextField(text: 'Точки: $points | Активни дни: ${streakDays.length}'),
                    trailing: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                      hasProfilePicture ? NetworkImage(imageUrl) : null,
                      child: hasProfilePicture ? null : const Icon(Icons.person),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMedalOrRank(int rank) {
    if (rank == 1) {
      return const Icon(Icons.emoji_events, color: Colors.yellow, size: 40);
    } else if (rank == 2) {
      return const Icon(Icons.emoji_events, color: Colors.grey, size: 40);
    } else if (rank == 3) {
      return const Icon(Icons.emoji_events, color: Colors.orange, size: 40);
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: MyTextField(text: rank.toString(),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
