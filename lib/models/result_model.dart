class ResultModel {
  String quizId;
  String userMail;
  int correct;
  int incorrect;
  int notAttempted;
  int total;

  ResultModel(this.quizId, this.userMail, this.correct, this.incorrect, this.notAttempted, this.total);
}