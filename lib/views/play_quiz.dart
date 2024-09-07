import 'package:flutter/material.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/models/question.dart';
import 'package:quiz_maker/models/result_model.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/views/results.dart';
import 'package:quiz_maker/widgets/quiz_play_widget.dart';

import '../components/app_bar.dart';
import '../main.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final String currentUserMail;

  const PlayQuiz(this.quizId, this.currentUserMail);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  QuizService _db = QuizService();
  List<Question> _questions = [];
  int _correct = 0;
  int _incorrct = 0;
  int _notAttempted = 0;

  @override
  void initState() {
    _db.getQuestionsForQuiz(widget.quizId).then((val) {
      logger.i("Questions are:  ${val.length}.");
      setState(() {
        _questions = val;
        _notAttempted = val.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: ''),
      body: _questions.isEmpty
          ? const Center(
              child: SizedBox(
                width: 250,
                child: MyTextField(text: 'За този тест все още няма добавени въпроси.',
                  fontSize: 22,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return QuizOptions(
                        question: QuestionModel(_questions[index]),
                        index: index,
                        onOptionSelected: (bool isCorrect) {
                          _notAttempted--;
                          isCorrect ? _correct++ : _incorrct;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>
                  Results(result: ResultModel(widget.quizId, widget.currentUserMail, _correct, _incorrct, _notAttempted, _questions.length))
              )
          );
        },
      ),
    );
  }
}

class QuizOptions extends StatefulWidget {
  final QuestionModel question;
  final int index;
  final ValueChanged<bool> onOptionSelected;

  const QuizOptions({super.key, required this.question, required this.index, required this.onOptionSelected});

  @override
  State<QuizOptions> createState() => _QuizOptionsState();
}

class _QuizOptionsState extends State<QuizOptions> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(
            text: "${widget.index + 1}. ${widget.question.question}",
            fontSize: 22,
          ),
          const SizedBox(
            height: 10,
          ),
          ...widget.question.options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            if (option.isNotEmpty) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      optionClick(option);
                    },
                    child: OptionTile(
                      option: String.fromCharCode(65 + index),
                      description: option,
                      correctAnswer: widget.question.correctOption,
                      optionSelected: optionSelected,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            } else {
              return Container(); // or SizedBox.shrink() to avoid rendering anything for empty options
            }
          }).toList(),
        ],
      ),
    );
  }

  void optionClick(String option) {
    if (!widget.question.answered) {
      widget.question.answered = true;
      optionSelected = option;
      bool isCorrect = widget.question.correctOption == option;
      widget.onOptionSelected(isCorrect);
      setState(() {});
    }
  }
}
