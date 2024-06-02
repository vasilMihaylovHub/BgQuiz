import 'package:flutter/material.dart';
import 'package:quiz_maker/models/question.dart';
import 'package:quiz_maker/services/database.dart'; // Import your Question model

class QuizSolvingScreen extends StatefulWidget {
  final String quizId;

  const QuizSolvingScreen({Key? key, required this.quizId})
      : super(key: key);

  @override
  _QuizSolvingScreenState createState() => _QuizSolvingScreenState();
}

class _QuizSolvingScreenState extends State<QuizSolvingScreen> {
  List<String?> selectedAnswers = [];
  List<Question> questions = [];
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    _db.getQuestionsForQuiz(widget.quizId)
    .then((val){
      setState(() {
        questions = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Решаване на теста',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue
        ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: questions.isEmpty
          ? const Center(
        child: SizedBox(
          width: 250,
          child: Text(
            'За този тест все още не са добавени въпроси.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      )
          : ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Question ${index + 1}: ${question.question}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text(question.option1),
                  leading: Radio(
                    value: question.option1,
                    groupValue: selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value as String?;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(question.option2),
                  leading: Radio(
                    value: question.option2,
                    groupValue: selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value as String?;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(question.option3),
                  leading: Radio(
                    value: question.option3,
                    groupValue: selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value as String?;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(question.option4),
                  leading: Radio(
                    value: question.option4,
                    groupValue: selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value as String?;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          // Implement logic to calculate score or submit answers
        },
      ),
    );
  }
}
