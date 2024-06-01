import 'package:flutter/material.dart';
import 'package:quiz_maker/views/home.dart';

import '../services/database.dart';
import '../widgets/widgets.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  const AddQuestion({super.key, required this.quizId});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  DatabaseService databaseService = DatabaseService();
  bool isLoading = false;

  saveQuiz() {
    uploadQuestion();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));

  }


  void processToNextQuestion() {
    uploadQuestion();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AddQuestion(quizId: widget.quizId)));
  }


  uploadQuestion() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };
      databaseService.addQuestionToQuiz(widget.quizId, questionMap).then((quizId) {

      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
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
                      decoration: const InputDecoration(hintText: "Question"),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      //add more validations
                      validator: (val) => val!.isEmpty ? "Option one" : null,
                      decoration:
                          const InputDecoration(hintText: "Правилният отговор"),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter description" : null,
                      decoration: const InputDecoration(hintText: "Опция две"),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Опция trie"),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Опция четири"),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              saveQuiz();
                            },
                            child: blueButton(context: context,
                                label:  "Запази теста",
                                buttonWidth: MediaQuery.of(context).size.width/2 - 48
                            )
                        ),
                        const SizedBox(width: 24,),
                        GestureDetector(
                            onTap: () {
                              processToNextQuestion();
                            },
                            child: blueButton(context: context,
                                label:  "Добави въпрос",
                                buttonWidth: MediaQuery.of(context).size.width/2 - 48
                            )
                        ),

                      ]
                    ),
                    const SizedBox(height: 60,)
                  ],
                ),
              ),
            ),
    );
  }
}
