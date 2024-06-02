import 'package:flutter/material.dart';
import 'package:quiz_maker/models/question.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/widgets/quiz_play_widget.dart';

import '../widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  const PlayQuiz({Key? key, required this.quizId});

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService _db = DatabaseService();
  List<Question> _questions = [];
  int _notAttempted = 0;
  int _correct = 0;
  int _incorrect = 0;
  int _total = 0;

  @override
  void initState() {
    _db.getQuestionsForQuiz(widget.quizId).then((val) {
      print("Questions are:  ${val.length}.");
      setState(() {
        _questions = val;
        _notAttempted = 0;
        _correct = 0;
        _incorrect = 0;
        _total = _questions.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: _questions.isEmpty
          ? const Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  'За този тест все още няма добавени въпроси.',
                  style: TextStyle(fontSize: 22),
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
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class QuizOptions extends StatefulWidget {
  final QuestionModel question;
  final int index;

  const QuizOptions({super.key, required this.question, required this.index});

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
          Text(
            "${widget.index + 1}. ${widget.question.question}",
            style: TextStyle(fontSize: 22, color: Colors.black87),
          ),
          SizedBox(
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
                  SizedBox(
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
      if (widget.question.correctOption == option) {
        // _correct = _correct++
      } else {
        //_incorrct++
      }
    }
    setState(() {});
  }
}
