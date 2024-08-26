import 'package:flutter/material.dart';

import '../views/add_question.dart';

class ActionButtons extends StatelessWidget {
  final String quizId;
  final VoidCallback onDelete;

  const ActionButtons({
    super.key,
    required this.quizId,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: navigateOnAddQuestion(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }

  navigateOnAddQuestion(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute( builder: (context) =>
        AddQuestion(quizId: quizId)));
  }
}
