class QuizModel {
  final String title;
  final String answer;
  final String? uid;
  QuizModel({
    required this.title,
    required this.answer,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'answer': answer,
      'uid': uid,
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      title: map['title'] as String,
      answer: map['answer'] as String,
      uid: map['uid'] as String,
    );
  }

  QuizModel copyWith({
    String? title,
    String? answer,
    String? uid,
  }) {
    return QuizModel(
      title: title ?? this.title,
      answer: answer ?? this.answer,
      uid: uid ?? this.uid,
    );
  }
}
