import 'package:flutter/material.dart';

class QuizCoverImage extends StatelessWidget {
  final String imgUrl;

  const QuizCoverImage({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
        child: Image.network(imgUrl),
    );
  }
}
