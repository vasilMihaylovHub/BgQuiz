import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> quizzesFuture;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    quizzesFuture = databaseService.getQuizzes();
  }

  void refreshQuizzes() {
    setState(() {
      quizzesFuture = databaseService.getQuizzes();
    });
  }

  Widget quizList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: quizzesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No quizzes available'));
        } else {
          var quizzes = snapshot.data!;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              var quiz = quizzes[index];
              return QuizTitle(
                quiz['quizData']['quizImgUrl'],
                quiz['quizData']['quizTitle'],
                quiz['quizData']['quizDescription'],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuiz(),
            ),
          );
          refreshQuizzes(); // Refresh quizzes after coming back from the CreateQuiz screen
        },
      ),
    );
  }
}

class QuizTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;

  QuizTitle(this.imgUrl, this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Stack(
        children: [
          Image.network(imgUrl),
          Container(
            child: Column(
              children: [
                Text(title),
                Text(desc),
              ],
            ),
          )
        ],
      ),
    );
  }
}