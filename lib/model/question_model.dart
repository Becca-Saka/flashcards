import 'dart:convert';

class QuestionModel {
  final String id;
  final String question;
  final String answer;
  final bool? answeredCorrectly;

  QuestionModel({
    required this.id,
    required this.question,
    required this.answer,
    this.answeredCorrectly,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'answered_correctly': answeredCorrectly,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      answeredCorrectly: map['answered_correctly'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source));

  QuestionModel answerQuestion(bool answeredCorrectly) {
    return QuestionModel(
      id: id,
      question: question,
      answer: answer,
      answeredCorrectly: answeredCorrectly,
    );
  }
}
