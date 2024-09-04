import 'package:flutter/material.dart';
import 'package:quiz_maker/common/constants.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/services/auth_service.dart';

import '../widgets/widgets.dart';
import 'add_question.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizTitle, quizDesc, quizImgUrl;
  bool isLoading = false;
  QuizService databaseService = QuizService();
  AuthService authService = AuthService();


  createQuiz() async {

    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      final currentUser = await authService.getCurrentUser();

      final newQuiz = Quiz(
        name: quizTitle,
        imgUrl: quizImgUrl,
        description: quizDesc,
        creatorEmail: currentUser?.email ?? Constants.defaultMail,
        likes: []
      );
      databaseService.createQuiz(newQuiz)
      .then((creationSuccess) {
        if(creationSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => AddQuestion(quizId: newQuiz.id))
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неуспешно създаван на тест. Моля опитайте отново'))
          );
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Създаване на тест'),
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
                decoration: InputDecoration(hintText: "Профилна снимка, URL"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Заглавие"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Описание"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    createQuiz();
                  },
                  child: blueButton(context: context,label: "Създай")
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
