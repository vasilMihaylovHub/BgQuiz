import 'package:flutter/material.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/views/add_question.dart';

import '../widgets/widgets.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String image, title, description;
  DatabaseService databaseService = DatabaseService();
  bool isLoading = false;

  createQuiz() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> quizMap = {
        "quizImgUrl": image,
        "quizTitle": title,
        "quizDescription": description,
      };
      databaseService.addQuizData(quizMap).then((quizId) {
        setState(() {
          isLoading = false;
        });
        print('Quiz created with ID: $quizId');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddQuestion(quizId: quizId)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Quiz Image Url"),
                      onChanged: (img) {
                        image = img;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      //add more validations
                      validator: (val) => val!.isEmpty ? "Enter title" : null,
                      decoration: const InputDecoration(hintText: "Quiz title"),
                      onChanged: (val) {
                        title = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter description" : null,
                      decoration:
                          const InputDecoration(hintText: "Quiz Description"),
                      onChanged: (val) {
                        description = val;
                      },
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          createQuiz();
                        },
                        child: blueButton(context: context,label: "Create Quiz")),
                    const SizedBox(height: 60)
                  ],
                ),
              ),
          ),
    );
  }
}
