import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Question.dart';
import '../models/quiz.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Quiz>> getQuizzesStream() {
    return _db.collection('quizzes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Quiz.fromFirestore(doc)).toList();
    });
  }

  Future<void> createQuiz(Quiz quiz) {
    try {
      return _db.collection('quizzes').doc(quiz.id).set(quiz.toJson());
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  Future<void> deleteQuiz(String quizId) {
    return _db.collection('quizzes').doc(quizId).delete();
  }

  Future<void> addQuestion(Question question) async {
    return _db
        .collection('questions')
        .doc(question.id)
        .set(question.toJson());
  }


  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    QuerySnapshot querySnapshot = await _db.collection('questions').where(
        'quizId', isEqualTo: quizId).get();
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