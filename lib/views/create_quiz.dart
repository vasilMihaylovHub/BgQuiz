import 'package:flutter/material.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:uuid/uuid.dart';

import '../widgets/widgets.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizTitle, quizDesc, quizImgUrl;
  bool isLoading = false;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();


  createQuiz() async {

    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      final currentUser = await authService.getCurrentUser();

      final quizId = Uuid().v4();
      final newQuiz = Quiz(
        id: quizId,
        name: quizTitle,
        imgUrl: quizImgUrl,
        description: quizDesc,
        creatorEmail: currentUser?.email ?? "mail@not.found",
      );
      databaseService.createQuiz(newQuiz).then((val) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
        /*print('Quiz created with ID: $quizId');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddQuestion(quizId: quizId)));*/
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Quiz Image URL"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    createQuiz();
                  },
                  child: blueButton(context: context,label: "Create Quiz")
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
