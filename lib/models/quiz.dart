import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String id;
  String name;
  String imgUrl;
  String description;
  String creatorEmail;
  List<String> likes;

  Quiz({
    String? id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.creatorEmail,
    required this.likes,
  }): id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  factory Quiz.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Quiz(
      id: doc.id,
      name: data['quizTitle'],
      imgUrl: data['quizImgUrl'],
      description: data['quizDescription'],
      creatorEmail: data['creatorEmail'],
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizTitle': name,
      'quizImgUrl': imgUrl,
      'quizDescription': description,
      'creatorEmail': creatorEmail,
      'likes': likes,
    };
  }
}