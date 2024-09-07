import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/constants.dart';
import '../main.dart';
import '../models/question.dart';
import '../models/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Quiz>> getQuizzesStream() {
    return _db
        .collection(Constants.quizzesDbDocument)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Quiz.fromFirestore(doc)).toList();
    });
  }

  Future<bool> createQuiz(Quiz quiz) async {
    logger.i("Creating quiz: ${quiz.name}");

    try {
      await _db
          .collection(Constants.quizzesDbDocument)
          .doc(quiz.id)
          .set(quiz.toJson());
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  Future<void> deleteQuiz(String quizId) {
    logger.i("Delete quiz $quizId");
    return _db.collection(Constants.quizzesDbDocument).doc(quizId).delete();
  }

  Future<bool> addQuestion(Question question) async {
    logger.i("Add question ${question.toString()}");

    try {
      await _db
          .collection(Constants.questionsDbDocument)
          .doc(question.id)
          .set(question.toJson());
      return true;
    } on Exception catch (ex) {
      logger.e("Error in addQuestion: $ex");
      return false;
    }
  }

  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    logger.i("getQuestionsForQuiz $quizId");

    QuerySnapshot querySnapshot = await _db
        .collection(Constants.questionsDbDocument)
        .where('quizId', isEqualTo: quizId)
        .get();
    return querySnapshot.docs.map((doc) {
      return Question(
        id: doc.id,
        quizId: quizId,
        question: doc['question'],
        option1: doc['option1'],
        option2: doc['option2'],
        option3: doc['option3'],
        option4: doc['option4'],
      );
    }).toList();
  }

  void likeQuiz(String quizId, String currUserMail) async {
    logger.i("liking... $quizId");

    DocumentReference quizReference =
        _db.collection(Constants.quizzesDbDocument).doc(quizId);

    quizReference.update({
      'likes': FieldValue.arrayUnion([currUserMail])
    });
  }

  Future<void> solvedQuiz(String quizId, String currUserMail) async {
    logger.i("Solved $quizId, by: $currUserMail");

    DocumentReference quizReference =
        _db.collection(Constants.quizzesDbDocument).doc(quizId);

    return quizReference.update({
      'solved': FieldValue.arrayUnion([currUserMail])
    });
  }

  void dislikeQuiz(String quizId, String currUserMail) {
    logger.i("liking... $quizId");

    DocumentReference quizReference =
        _db.collection(Constants.quizzesDbDocument).doc(quizId);

    quizReference.update({
      'likes': FieldValue.arrayRemove([currUserMail])
    });
  }
}
