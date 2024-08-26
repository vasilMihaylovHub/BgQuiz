import 'package:flutter/material.dart';

class QuizCoverImage extends StatelessWidget {
  final String imgUrl;
  final String defaultImg =
      'https://m.netinfo.bg/media/images/32645/32645792/991-ratio-karta-bylgariia.jpg';

  const QuizCoverImage({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,

        child: Image.network(imgUrl, errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Container(
              // color: const Color.fromRGBO(76, 207, 255, 0.8),// Light blue background as fallback
              );
        }),

    );
  }
}
