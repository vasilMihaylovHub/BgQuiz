import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';
import '../models/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Quiz>> getQuizzesStream() {
    return _db.collection('quizzes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Quiz.fromFirestore(doc)).toList();
    });
  }

  Future<bool> createQuiz(Quiz quiz) async {
    print("Create quiz ${quiz.toString()}");

    try {
      await _db.collection('quizzes').doc(quiz.id).set(quiz.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> deleteQuiz(String quizId) {
    print("Delete quiz $quizId");
    return _db.collection('quizzes').doc(quizId).delete();
  }

  Future<void> addQuestion(Question question) async {
    print("Add question ${question.toString()}");
    return _db.collection('questions').doc(question.id).set(question.toJson());
  }

  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    print("getQuestionsForQuiz $quizId");

    QuerySnapshot querySnapshot = await _db
        .collection('questions')
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
}
