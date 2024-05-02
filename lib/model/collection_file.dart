import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'quiz_model.dart';

class CollectionFile {
  final String id;
  final String name;
  final String path;
  final DateTime? updatedAt;
  final String? url;
  final List<QuizModel> quizzes;

  CollectionFile({
    required this.id,
    required this.name,
    required this.path,
    this.updatedAt,
    this.url,
    this.quizzes = const [],
  });

  CollectionFile.initial({
    required this.name,
    required this.path,
  })  : id = const Uuid().v4(),
        url = null,
        quizzes = const [],
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
      'url': url,
      'quizzes': quizzes.map((x) => x.toMap()).toList(),
    };
  }

  factory CollectionFile.fromMap(Map<String, dynamic> map) {
    return CollectionFile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
      url: map['url'],
      quizzes: List<QuizModel>.from(
          map['quizzes']?.map((x) => QuizModel.fromMap(x)) ?? const []),
    );
  }

  CollectionFile copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? updatedAt,
    String? url,
    List<QuizModel>? quizzes,
  }) {
    return CollectionFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      updatedAt: DateTime.now(),
      url: url ?? this.url,
      quizzes: quizzes ?? this.quizzes,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionFile.fromJson(String source) =>
      CollectionFile.fromMap(json.decode(source));

  FileType get type => FileType.fromPath(path);
  String get mimeType {
    return type == FileType.pdf
        ? 'application/pdf'
        : 'image/${name.split('.').last.toLowerCase()}';
  }
}

enum FileType {
  image('image', 'image/jpeg'),
  pdf('pdf', 'application/pdf');

  final String value;
  final String mimeType;
  const FileType(this.value, this.mimeType);

  factory FileType.fromPath(String path) {
    if (path.split('.').last == 'pdf') {
      return FileType.pdf;
    }
    return FileType.image;
  }
}
