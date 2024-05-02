import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcards/model/collection_file.dart';
import 'package:flashcards/shared/prompts.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';

import '../../firebase_options.dart';
import '../../model/collection_model.dart';
import '../../model/quiz_model.dart';

abstract class IGeminiService {
  Future<CollectionModel> uploadCollectionFiles(
      CollectionModel model, List<CollectionFile> collectionFiles);
  Future<List<QuizModel>> generateQuiz(CollectionFile files);
}

class GeminiService extends IGeminiService {
  final _dio = Dio();
  final _log = Logger();

  final res = {
    "type": "service_account",
    "project_id": "jarvis-security-419415",
    "private_key_id": "91bde507c1f23c1ff948e9930f9dcb9daccbdb9b",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCxncAb/wzgf0rh\naGoQ1qPaTXm5UJVxzBwdtFqx+p6IiiTShK6SOURZUQoDQMHjdkdIi4EBJ5340ACi\nQ43XiQdcGkwRi94SH3XjyFQYKLGtHqQE27PYbk3hBs5YEUKdmCzCTSDhxN1Lj1NT\nEdn2d8F9TjfHcE838EvYT7e/6lzbUDAKYzUUvjgeEDWCMUsk/DAweZrmCC/h9pZ4\nDUdxxtGyHpjv0e3yUnr+JgJVRe20T3pPvJskypGGk3CbnFxF5T6tjFaEhxxT/jsv\nv8EoOp9XcdwXgFyjwHpmo83/+Z66LBKeK0zry92/Mj1EiUBNrbZfcFR4p5pblfvN\n4xCZDT6XAgMBAAECggEAMqDt1s0f5YpDVPdHbJ9SO3LkJJ/EyZhN12XGiH8Q24jN\nMDjj7ghm5DLGcODvo5/ed95UGnkpfXgFBjvNXcfQkj9ouYOt/Gp9Vz2OQwiuhNN8\nG2po3GOszVz8Snw5CeULtSL5IYHVNqmXLdGj2K6QN+Co46+u1Roo9HLcxNbQOy8p\nGie8nk6E/R1slRnuYRRBZ543rF3sgvWbyIlbAv2HaPRNvqQ6uRjXFwfLJVUqQouB\n6OYq9cRBoWy7HpZNZWSDrR754p7bYdovbjihNqEIgwJXLdAzDHoeZpA3IBjbtMTq\nkB4HD5h6hO1BK+rEUmRWMmQuRaxNi3cWWnmzd0L7AQKBgQDsiUzoCGVS/eJzxaEk\nKIQXWR8KzshkETFLUjq1H6pyEivyunE4fprz9nw0juu5QqKU5swxVKRNalvH6mGp\nZ/HIq7w4NrBzxBWWKdNn/QsT+x0jY19G8HyyyY/Dq14kklKcaeOLD2C0LAbxWIxB\nJF6QLuu9S2JVrLRtGMrF5PYfFwKBgQDAO0hIHUF8JWvvVeMwxUL9Are3kDfEdUvh\nuQNEaP0cGYgURyNhJFnHBz11neUED14l6HAX3Y//tJWoyKuvu6bXn71po6CqY4O2\naFtGOf8A87ttum2DNiInAoTQGVM4TOxeTez3p0gezFSjtK5D7Lc/pCGj6N4B6Goe\nMRl4nJGMgQKBgQCWROfR5TuRzO8ng59K3F6Ggrzg3dubDv0VD+lyFervyzGWY/H3\n5R7F7IqdzUpeCMJG/JUupco30GD8kZ93wyxswwWxZLUW5rScEHhY8P4vtHGfgMsP\nw0pFPx4RPfZyH29SJUdEmgFilTHX89wuqk9VJCnpuVGAglahlIWF0V63AwKBgQCH\no4zuLY5+bd1KJH1JdXc+FcPSR3XCLs3bOPPgOoCWakGFpWiGa+LZN/ea3U2yXrGc\n5/ToMhMgZ6jOTsIuHqesL++z8Zw1fkB63gnBdLzFTDWtSEVrty/D/NgACk6ZRFXo\neO3DFYsjCCSU2rG4BfiLdGG0SWUVTYxLP3PskfV1gQKBgB1drbkfp8FPB+G8VIXs\n4dF+KIHEyxMCx9IAvDoQhyWOuNd2VvJ91wYMALrhwGSZrB313gciABijynEpZtsr\nVU9vvzpFZAHW248CLLdeUKatzRKIK0cHhqi/BLE/sCdXxPmN5zKbSvtI1fjYZaJP\n8nlHzUobfinTl7Eda7VkkGQ9\n-----END PRIVATE KEY-----\n",
    "client_email": "jarvis-security-419415@appspot.gserviceaccount.com",
    "client_id": "115445228853519879059",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/jarvis-security-419415%40appspot.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  Future<AuthClient> obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(res);
    var scopes = [
      'https://www.googleapis.com/auth/cloud-platform',
    ];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client;
  }

  @override
  Future<CollectionModel> uploadCollectionFiles(
      CollectionModel model, List<CollectionFile> collectionFiles) async {
    try {
      _log.d('generateQuiz');

      final client = await obtainAuthenticatedClient();

      final files = <CollectionFile>[];
      _dio.interceptors.add(LogInterceptor(requestHeader: false));
      const storageBucket = 'jarvis_security_bucket';

      final fileFolderAndName = 'flashcards/collections/${model.name}';

      const api = 'https://www.googleapis.com/upload/storage/v1/b';

      for (final file in collectionFiles) {
        String location = '$fileFolderAndName/${file.name}';
        final url = '$api/$storageBucket/o?uploadType=media&name=$location';

        final fileContent = await File(file.path).readAsBytes();
        final res = await _dio.post(
          url,
          options: Options(
            headers: {
              "Authorization": "Bearer ${client.credentials.accessToken.data}",
              "Content-Type": file.mimeType,
            },
          ),
          data: fileContent,
        );

        _log.d(res.data.toString());
        final result = res.data as Map<String, dynamic>;
        final idSplit = (result['id'] as String).split('/');

        final filelink =
            "gs://${idSplit.sublist(0, idSplit.length - 1).join('/')}";

        model.files.removeWhere((element) => element.id == file.id);
        files.add(file.copyWith(url: filelink));
      }
      client.close();
      return model.copyWith(files: [...model.files, ...files]);
    } on FirebaseException catch (e) {
      _log.e(e);
      throw Exception(e.message);
    } on DioException catch (e) {
      _log.e(e.response?.data);
      throw Exception(e.message);
    } on Exception catch (e) {
      _log.e(e);
      rethrow;
    }
  }

  @override
  Future<List<QuizModel>> generateQuiz(CollectionFile files) async {
    try {
      _log.d('generateQuiz');
      const vertexAiLocationId = "us-central1";
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;
      final client = await obtainAuthenticatedClient();
      _dio.interceptors.add(LogInterceptor(requestHeader: false));
      final promptData = {
        "role": "USER",
        "parts": [
          {"text": Prompts.first},
          {
            "fileData": {
              "mimeType": files.mimeType,
              "fileUri": files.url,
            },
          },
        ]
      };
      _log.d('Prompt data: $promptData');
      final res = await _dio.post(
        "https://$vertexAiLocationId-aiplatform.googleapis.com/v1/projects/$projectId/locations/$vertexAiLocationId/publishers/google/models/gemini-1.0-pro-vision:generateContent",
        options: Options(
          headers: {
            "Authorization": "Bearer ${client.credentials.accessToken.data}",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "contents": promptData,
          // "contents": {
          //   "role": "USER",
          //   "parts": [
          //     {"text": Prompts.first},
          //     {
          //       "fileData": {
          //         "mimeType": files.first.mimeType,
          //         "fileUri": files.first.url,
          //       },
          //     },
          //   ]
          // },
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

      final datax = res.data['candidates'][0]['content']['parts'][0]['text'];
      _log.d(datax);
      String data = datax as String;
      final firstJsonBracket = data.indexOf('{');
      int lastJsonBracket = data.lastIndexOf('}');
      if (lastJsonBracket == -1) lastJsonBracket = data.length;
      if (firstJsonBracket != -1 && lastJsonBracket != -1) {
        data = data.substring(firstJsonBracket, lastJsonBracket + 1);
        var cleanedData = jsonDecode(data.replaceAll('\\n', ' '));

        client.close();

        return (cleanedData["flashcards"] as List)
            .map((e) => QuizModel.fromMap(e, true))
            .toList();
      } else {
        _log.e('Failed to parse data');
        throw Exception('Something went wrong');
      }
    } on DioException catch (e) {
      _log.e(e.response?.data);
      throw Exception(e.message);
    } on Exception catch (e, s) {
      _log.e(e, stackTrace: s);
      rethrow;
    }
  }
}
