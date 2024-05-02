import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'collection_file.dart';

class CollectionModel extends Equatable {
  final String uid;
  final String name;
  final String description;
  final List<CollectionFile> files;
  final DateTime updatedAt;

  const CollectionModel({
    required this.uid,
    required this.name,
    required this.description,
    this.files = const [],
    required this.updatedAt,
  });

  CollectionModel.initial({
    required this.name,
    required this.description,
  })  : uid = const Uuid().v4(),
        files = [],
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'files': files.map((x) => x.toMap()).toList(),
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      files: List<CollectionFile>.from(
          map['files']?.map((x) => CollectionFile.fromMap(x)) ?? const []),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  CollectionModel copyWith({
    String? uid,
    String? name,
    String? description,
    List<CollectionFile>? files,
    DateTime? updatedAt,
  }) {
    return CollectionModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      files: files ?? this.files,
      updatedAt: DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionModel.fromJson(String source) =>
      CollectionModel.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      uid,
      name,
      description,
      updatedAt,
    ];
  }
}
