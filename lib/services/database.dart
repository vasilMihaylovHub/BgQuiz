import 'package:quiz_maker/common/constants.dart';
import 'dart:async';

class DatabaseService {
  final List<Map<String, dynamic>> _quizzes = [];
  int _quizCounter = 0;

  Future<String> addQuizData(Map<String, String> quizData) async {
    await Future.delayed(const Duration(seconds: Constants.databaseResponseTimeSeconds));

    String quizId = 'quizID${_quizCounter++}';
    quizData['quizId'] = quizId;
    _quizzes.add({
      'quizData': quizData,
      'questions': <Map<String, String>>[],
    });
    return quizId;
  }

  Future<void> addQuestionToQuiz(String quizId, Map<String, String> questionData) async {
    await Future.delayed(const Duration(seconds: Constants.databaseResponseTimeSeconds));
    try {
      for (var quiz in _quizzes) {
        if (quiz['quizData']['quizId'] == quizId) {
          (quiz['questions'] as List<Map<String, String>>).add(questionData);
          return;
        }
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Quiz not found');
    }
  }

  Future<List<Map<String, dynamic>>> getQuizzes() async {
    await Future.delayed(const Duration(seconds: Constants.databaseResponseTimeSeconds));

    return _quizzes;
  }

  Stream<List<Map<String, dynamic>>> getQuizzesSteam()  {

    return Stream.fromFuture(getQuizzes());
  }


}