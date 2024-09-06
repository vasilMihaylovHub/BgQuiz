class Constants {
  static const int databaseResponseTimeSeconds = 3;
  static const String defaultMail = "mail@not.found";
  static const String usersDbDocument = "users";
  static const String quizzesDbDocument = "quizzes";
  static const String questionsDbDocument = "questions";
}

class GamePoints {
  static const int initial = 0;
  static const int everyStreak = 2;
  static const double steakMultiplier = 1.1;
  static const int solvedQuiz80 = 3;
  static const int solvedQuiz100 = 5;
  static const int createdQuiz = 10;
  static const int likes = 0; //TODO
}
