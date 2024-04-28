import 'dart:convert';

class CollectionModel {
  final String id;
  final String name;
  final String description;
  final DateTime updatedAt;

  CollectionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionModel.fromJson(String source) =>
      CollectionModel.fromMap(json.decode(source));
}

enum FileType {
  image('image'),
  pdf('pdf');

  final String value;
  const FileType(this.value);

  Map<String, dynamic> toMap() {
    return {
      'value': value,
    };
  }

  factory FileType.fromMap(Map<String, dynamic> map) {
    switch (map['value']) {
      case 'image':
        return FileType.image;
      case 'pdf':
        return FileType.pdf;
      default:
        return FileType.image;
    }
  }
}

class CollectionAssetModel {
  final String id;
  final String name;
  final FileType type;
  final DateTime updatedAt;
  CollectionAssetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toMap(),
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CollectionAssetModel.fromMap(Map<String, dynamic> map) {
    return CollectionAssetModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: FileType.fromMap(map['type']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionAssetModel.fromJson(String source) =>
      CollectionAssetModel.fromMap(json.decode(source));
}
