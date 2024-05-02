import 'dart:convert';

import 'package:uuid/uuid.dart';

class QuizModel {
  final String id;
  final String fileId;
  final String question;
  final String answer;
  final bool? answeredCorrectly;

  QuizModel({
    required this.id,
    required this.fileId,
    required this.question,
    required this.answer,
    this.answeredCorrectly,
  });

  QuizModel.initial({
    required this.fileId,
    required this.question,
    required this.answer,
  })  : id = const Uuid().v4(),
        answeredCorrectly = null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_id': fileId,
      'question': question,
      'answer': answer,
      'answered_correctly': answeredCorrectly,
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] ?? '',
      fileId: map['file_id'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      answeredCorrectly: map['answered_correctly'],
    );
  }

  factory QuizModel.fromGemini(Map<String, dynamic> map, String fileId) {
    return QuizModel(
      id: const Uuid().v4(),
      fileId: fileId,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      answeredCorrectly: map['answered_correctly'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizModel.fromJson(String source) =>
      QuizModel.fromMap(json.decode(source));

  QuizModel answerQuestion(bool answeredCorrectly) {
    return QuizModel(
      id: id,
      fileId: fileId,
      question: question,
      answer: answer,
      answeredCorrectly: answeredCorrectly,
    );
  }

  bool get isAnswered => answeredCorrectly != null;

  QuizModel copyWith({
    String? id,
    String? fileId,
    String? question,
    String? answer,
    bool? answeredCorrectly,
  }) {
    return QuizModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      answeredCorrectly: answeredCorrectly ?? this.answeredCorrectly,
    );
  }
}
