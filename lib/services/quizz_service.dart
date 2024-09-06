import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constants.dart';
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
    print("Creating quiz: ${quiz.name}");

    try {
      await _db
          .collection(Constants.quizzesDbDocument)
          .doc(quiz.id)
          .set(quiz.toJson());
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> deleteQuiz(String quizId) {
    print("Delete quiz $quizId");
    return _db.collection(Constants.quizzesDbDocument).doc(quizId).delete();
  }

  Future<bool> addQuestion(Question question) async {
    print("Add question ${question.toString()}");

    try {
      await _db
          .collection(Constants.questionsDbDocument)
          .doc(question.id)
          .set(question.toJson());
      return true;
    } on Exception catch (ex) {
      print("Error in addQuestion: $ex");
      return false;
    }
  }

  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    print("getQuestionsForQuiz $quizId");

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
    print("liking... $quizId");

    DocumentReference quizReference =
        _db.collection(Constants.quizzesDbDocument).doc(quizId);

    quizReference.update({
      'likes': FieldValue.arrayUnion([currUserMail])
    });
  }

  void dislikeQuiz(String quizId, String currUserMail) {
    print("liking... $quizId");

    DocumentReference quizReference =
        _db.collection(Constants.quizzesDbDocument).doc(quizId);

    quizReference.update({
      'likes': FieldValue.arrayRemove([currUserMail])
    });
  }
}
