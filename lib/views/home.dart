import 'package:flutter/material.dart';
import 'package:quiz_maker/components/action_buttons.dart';
import 'package:quiz_maker/components/drawer.dart';
import 'package:quiz_maker/components/quiz_cover_image.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/views/add_question.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/views/play_quiz.dart';
import 'package:quiz_maker/views/profile.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../common/constants.dart';
import '../components/text_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  QuizService quizService = QuizService();
  AuthService authService = AuthService();
  String? currentUserEmail;
  bool userLoading = true;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
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

  void loadCurrentUser() {
    authService.getCurrentUser().then((user) {
      setState(() {
        currentUserEmail = user?.email;
      });
    }).whenComplete(() {
      setState(() {
        userLoading = false;
      });
    });
  }

  Widget quizList() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder<List<Quiz>>(
          stream: quizService.getQuizzesStream(),
          builder: (context, snapshot) {
            if (userLoading ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Няма създаддени тестове.'));
            } else {
              var quizzes = snapshot.data!;
              return ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  var quiz = quizzes[index];
                  bool showActions = [currentUserEmail, Constants.defaultMail]
                      .contains(quiz.creatorEmail);
                  return QuizTitle(quiz.imgUrl, quiz.name, quiz.description,
                      quiz.id, showActions, () {
                    deleteQuiz(quiz.id);
                  }, () {
                    navigateOnAddQuestion(context, quiz.id);
                  });
                },
              );
            }
          },
        ));
  }

  navigateOnAddQuestion(BuildContext context, String quizId) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddQuestion(quizId: quizId)));
  }

  Future<void> deleteQuiz(String quizId) async {
    await quizService.deleteQuiz(quizId);
  }
}

class QuizTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  final bool showActions;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  QuizTitle(this.imgUrl, this.title, this.desc, this.quizId, this.showActions,
      this.onDelete, this.onEdit,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayQuiz(quizId: quizId),
          ),
        );
      },
      child: Card(
        child: SizedBox(
          height: 200.0, // Set the desired smaller height here
          child: Stack(
            children: [
              QuizCoverImage(imgUrl: imgUrl),
              Padding(
                padding: const EdgeInsets.all(20), // Adjust padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                        text: title, fontWeight: FontWeight.bold, fontSize: 18),
                    SizedBox(height: 8.0),
                    MyTextField(text: desc),
                    Spacer(),
                    // Conditional Action Buttons
                    if (showActions)
                      ActionButtons(
                        quizId: quizId,
                        onDelete: onDelete,
                        onEdit: onEdit,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
