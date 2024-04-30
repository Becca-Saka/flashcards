import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcards/model/collection_file.dart';

import '../../firebase_options.dart';
import '../../model/collection_model.dart';
import '../../model/quiz_model.dart';
import '../../shared/prompts.dart';

abstract class IGeminiService {
  Future<CollectionModel> uploadCollectionFiles(CollectionModel model);
  Future<List<QuizModel>> generateQuiz(List<CollectionFile> files);
}

class GeminiService extends IGeminiService {
  final _storage = FirebaseStorage.instance;
  final _dio = Dio();

  @override
  Future<CollectionModel> uploadCollectionFiles(CollectionModel model) async {
    try {
      final files = <CollectionFile>[];
      final collectionRef = _storage.ref().child("collections/${model.name}");

      for (final file in model.files) {
        final ref = collectionRef.child("files/${file.name}");
        await ref.putFile(File(file.path));
        final url = await ref.getDownloadURL();
        files.add(file.copyWith(url: url));
      }

      return model.copyWith(files: files);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<QuizModel>> generateQuiz(List<CollectionFile> files) async {
    const vertexAiLocationId = "us-central1";
    final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

    final res = await _dio.post(
      "https://$vertexAiLocationId-aiplatform.googleapis.com/v1/projects/$projectId/locations/$vertexAiLocationId/publishers/google/models/gemini-1.0-pro-vision:generateContent",
      options: Options(
        headers: {
          "Authorization": "Bearer auth_token",
          "Content-Type": "application/json",
        },
      ),
      data: {
        "contents": {
          "role": "USER",
          "parts": [
            // ...files.map(
            //   (e) =>
            {
              "fileData": {
                "mimeType": files.first.type.mimeType,
                "fileUri": files.first.url,
              }
            },
            // ),
            {
              "text": Prompts.first,
            },
          ]
        },
        "safety_settings": [
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_NONE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_NONE"
          }
        ],
        "generation_config": {
          "temperature": 0.4,
          "topP": 1,
          "topK": 32,
          "maxOutputTokens": 2048,
        }
      },
    );

    print(res.data);

    final data = res.data['candidates'][0]['content']['parts'][0]['text'];

    print(data);
    return [];
  }
}
