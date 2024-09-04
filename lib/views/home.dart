import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/components/action_buttons.dart';
import 'package:quiz_maker/components/drawer.dart';
import 'package:quiz_maker/components/like_button.dart';
import 'package:quiz_maker/components/quiz_cover_image.dart';
import 'package:quiz_maker/components/streak_icon.dart';
import 'package:quiz_maker/models/quiz.dart';
import 'package:quiz_maker/services/auth_service.dart';
import 'package:quiz_maker/services/quizz_service.dart';
import 'package:quiz_maker/views/add_question.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/views/play_quiz.dart';
import 'package:quiz_maker/widgets/widgets.dart';

import '../components/text_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool userLoading = true;

  @override
  void initState() {
    super.initState();
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
          StreakIconButton(),
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
        }
      )
    );
  }


  Widget quizList() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder<List<Quiz>>(
          stream: QuizService().getQuizzesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                  return QuizTitle(quiz);
                },
              );
            }
          },
        ));
  }
}

class QuizTitle extends StatefulWidget {
  final Quiz quiz;

  QuizTitle(this.quiz,
      {super.key});

  @override
  State<QuizTitle> createState() => _QuizTitleState();
}

class _QuizTitleState extends State<QuizTitle> {
  bool isLiked = false;
  bool showActions = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    showActions = currentUser?.email == widget.quiz.creatorEmail;
    isLiked = widget.quiz.likes.contains(currentUser?.email ?? "");
  }

  toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    final currUserMail = AuthService().authInstance.currentUser!.email!;

    if(isLiked){
      QuizService().likeQuiz(widget.quiz.id, currUserMail);
    } else {
      QuizService().dislikeQuiz(widget.quiz.id, currUserMail);
    }
  }

  navigateOnAddQuestion(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddQuestion(quizId: widget.quiz.id)));
  }

  Future<void> deleteQuiz() async {
    await QuizService().deleteQuiz(widget.quiz.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayQuiz(widget.quiz.id),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // Adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            text: widget.quiz.name,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          SizedBox(height: 8.0),
                          MyTextField(text: widget.quiz.description),
                          SizedBox(height: 16.0)
                        ],
                      ),
                      SizedBox(
                        height: 150.0,
                        child: QuizCoverImage(imgUrl: widget.quiz.imgUrl),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          LikeButton(isLiked, toggleLike),
                          const SizedBox(height: 5),
                          Text(widget.quiz.likes.length.toString(),
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary))
                        ],
                      ),
                      Row(
                        children: [
                          if (showActions)
                            ActionButtons(
                              onDelete: () {deleteQuiz();},
                              onEdit: navigateOnAddQuestion(context),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
