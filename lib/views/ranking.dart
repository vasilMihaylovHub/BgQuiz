import 'package:flutter/material.dart';
import 'package:quiz_maker/services/user_service.dart';

class RankingPage extends StatelessWidget {
  final UserService userService= UserService();

  RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Ranking',
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
        body: StreamBuilder(
            stream: userService.getUsers(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              } else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.only(left: 30),
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']),// TODO: add points
                      );
                    }),
              );
            })
    );
  }
}
