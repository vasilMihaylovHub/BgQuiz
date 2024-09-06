import 'package:flutter/material.dart';
import '../components/app_bar.dart';
import '../models/question.dart';
import '../services/quizz_service.dart';
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
  QuizService databaseService = QuizService();
  bool isLoading = false;

  saveQuiz() async {
    if (_formKey.currentState?.validate() == true) {

      await uploadQuestion((){
        Navigator.pop(context);
      });
    }
  }

  Future<void> processToNextQuestion() async {
    if (_formKey.currentState?.validate() == true) {
      await uploadQuestion((){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddQuestion(quizId: widget.quizId)));
      });

    }
  }

  Future<bool> uploadQuestion(Function onSuccess) async {
    setState(() {
      isLoading = true;
    });

    Question questionForSave = Question(
      quizId: widget.quizId,
      question: question,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
    );
    bool savedSuccessFully = await databaseService.addQuestion(questionForSave);

    setState(() {
      isLoading = false;
    });

    if(savedSuccessFully){
      onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неуспешно запазен въпрос. Моля опитайте отново'))
      );
    }

    return savedSuccessFully;
  }

  void _openChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Chat with AI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // Add your chat messages here.
                      const Text('AI: How can I help you today?'),
                    ],
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (message) {
                    // Handle sending message to AI API
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(title: 'Нов въпрос'),
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
                validator: (val) => val!.isEmpty ? "Полето е задължително" : null,
                decoration: const InputDecoration(hintText: "Въпрос"),
                onChanged: (val) {
                  question = val;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Полето е задължително" : null,
                decoration: const InputDecoration(hintText: "Правилният отговор"),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Полето е задължително" : null,
                decoration: const InputDecoration(hintText: "Опция две"),
                onChanged: (val) {
                  option2 = val;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Полето е задължително" : null,
                decoration: const InputDecoration(hintText: "Опция три"),
                onChanged: (val) {
                  option3 = val;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Полето е задължително" : null,
                decoration: const InputDecoration(hintText: "Опция четири"),
                onChanged: (val) {
                  option4 = val;
                },
              ),
              const Spacer(),
              Row(children: [
                GestureDetector(
                    onTap: () {
                      saveQuiz();
                    },
                    child: blueButton(
                        context: context,
                        label: "Запази теста",
                        buttonWidth:
                        MediaQuery.of(context).size.width / 2 - 48)),
                const SizedBox(
                  width: 24,
                ),
                GestureDetector(
                    onTap: () {
                      processToNextQuestion();
                    },
                    child: blueButton(
                        context: context,
                        label: "Добави въпрос",
                        buttonWidth:
                        MediaQuery.of(context).size.width / 2 - 48)),
              ]),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openChatBottomSheet(context);
        },
        child: const Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
