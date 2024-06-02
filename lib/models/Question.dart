
class Question {
  String id;
  String quizId;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;

  Question({
    required this.id,
    required this.quizId,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
    };
  }
}