class CollectionModel {
  final String name;
  final String description;
  final String? uid;
  final List<CollectionFile>? files;
  CollectionModel({
    required this.name,
    required this.description,
    this.uid,
    this.files = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'uid': uid,
      'files': files?.map((x) => x.toMap()).toList(),
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      name: map['name'] as String,
      description: map['description'] as String,
      uid: map['uid'] as String,
      files: map['files'] != null
          ? List<CollectionFile>.from((map['files'] as List)
              .map((x) => CollectionFile.fromMap(x as Map<String, dynamic>)))
          : null,
    );
  }

  CollectionModel copyWith({
    String? name,
    String? description,
    String? uid,
    List<CollectionFile>? files,
  }) {
    return CollectionModel(
      name: name ?? this.name,
      description: description ?? this.description,
      uid: uid ?? this.uid,
      files: files ?? this.files,
    );
  }
}

class CollectionFile {
  final String name;
  final String path;
  CollectionFile({
    required this.name,
    required this.path,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'path': path,
    };
  }

  factory CollectionFile.fromMap(Map<String, dynamic> map) {
    return CollectionFile(
      name: map['name'] as String,
      path: map['path'] as String,
    );
  }

  CollectionFile copyWith({
    String? name,
    String? path,
  }) {
    return CollectionFile(
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }
}
