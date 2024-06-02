import 'package:flutter/material.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/views/signin.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../common/constants.dart';
import '../common/functions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    authService.getCurrentUser().then((user) {
      setState(() {
        currentUserEmail = user?.email;
      });
    });
  }

  Widget quizList() {
    return StreamBuilder<List<Quiz>>(
      stream: databaseService.getQuizzesStream(),
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
                quiz.imgUrl,
                quiz.name,
                quiz.description,
                [currentUserEmail, Constants.defaultMail].contains(quiz.creatorEmail),
                    () {
                  deleteQuiz(quiz.id);
                },
              );
            },
          );
        }
      },
    );
  }

  Future<void> deleteQuiz(String quizId) async {
    await databaseService.deleteQuiz(quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30),
            onPressed: () {
              signOut();
            },
          ),
        ],
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
        },
      ),
    );
  }

  void signOut() {
    authService.signOut().then((val) {
      HelperFunctions.saveCurrentUser(isLoggedIn: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    });
  }
}

class QuizTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final bool canDelete;
  final VoidCallback onDelete;

  QuizTitle(this.imgUrl, this.title, this.desc, this.canDelete, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imgUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(desc),
          ),
          if (canDelete)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }
}