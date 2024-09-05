import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/components/quiz_cover_image.dart';
import 'package:quiz_maker/components/text_field.dart';
import '../models/quiz.dart';
import '../services/auth_service.dart';
import '../services/quizz_service.dart';
import '../views/add_question.dart';
import '../views/play_quiz.dart';
import 'action_buttons.dart';
import 'like_button.dart';

class QuizTile extends StatefulWidget {
  final Quiz quiz;

  QuizTile(this.quiz,
      {super.key});

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
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