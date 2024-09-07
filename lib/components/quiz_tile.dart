import 'package:flutter/material.dart';
import 'package:quiz_maker/components/quiz_cover_image.dart';
import 'package:quiz_maker/components/text_field.dart';

import '../models/quiz.dart';
import '../services/quizz_service.dart';
import '../views/add_question.dart';
import '../views/play_quiz.dart';
import 'action_buttons.dart';
import 'like_button.dart';

class QuizTile extends StatefulWidget {
  final Quiz quiz;
  final String currentUserMail;

  QuizTile(this.quiz, this.currentUserMail, {super.key});

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  late bool isLiked;
  late bool showActions;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    _setQuizOptions();
  }

  void _setQuizOptions() {
    setState(() {
      showActions = widget.currentUserMail == widget.quiz.creatorEmail;
      isLiked = widget.quiz.likes.contains(widget.currentUserMail);
      isCompleted = widget.quiz.solved.contains(widget.currentUserMail);//change
    });
  }

  toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });


    if (isLiked) {
      QuizService().likeQuiz(widget.quiz.id, widget.currentUserMail);
    } else {
      QuizService().dislikeQuiz(widget.quiz.id, widget.currentUserMail);
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
            builder: (context) => PlayQuiz(widget.quiz.id, widget.currentUserMail),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isCompleted)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 23,
                                ),
                              ),

                            MyTextField(
                              text: widget.quiz.name,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            const SizedBox(height: 8.0),
                            MyTextField(text: widget.quiz.description),
                            const SizedBox(height: 16.0)
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
                                onDelete: () { deleteQuiz();},
                                onEdit: () { navigateOnAddQuestion(context);},
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
      ),
    );
  }
}