import 'dart:convert';

class CollectionFile {
  final String id;
  final String name;
  final String path;
  final DateTime? updatedAt;

  CollectionFile({
    required this.id,
    required this.name,
    required this.path,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
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
    );
  }

  CollectionFile copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? updatedAt,
  }) {
    return CollectionFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionFile.fromJson(String source) =>
      CollectionFile.fromMap(json.decode(source));

  FileType get type => FileType.fromPath(path);
}

enum FileType {
  image('image'),
  pdf('pdf');

  final String value;
  const FileType(this.value);

  factory FileType.fromPath(String path) {
    if (path.split('/').last == 'pdf') {
      return FileType.image;
    }
    return FileType.image;
  }
}
