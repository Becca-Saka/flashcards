import 'package:collection/collection.dart';
import 'package:flashcards/app/locator.dart';

import '../../model/quiz_model.dart';
import 'collection_service.dart';

abstract class IQuizService {
  Future<void> storeQuestions(
    String collectionId,
    String fileId,
    List<QuizModel> questions,
  );

  List<QuizModel> getQuestions(String collectionId, String fileId);

  List<QuizModel> getAllQuestions(String collectionId);

  Future<void> resetQuestions(String collectionId);

  Future<void> answerQuestion(
    String collectionId,
    String fileId,
    String questionId,
    bool answeredCorrectly,
  );
}

class QuizService extends IQuizService {
  final _collectionService = locator<ICollectionService>();

  @override
  Future<void> storeQuestions(
    String collectionId,
    String fileId,
    List<QuizModel> questions,
  ) async {
    try {
      /// Collections
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) {
        throw Exception('Collection not found');
      }

      /// Files
      final files = collections[collectionIndex].files;
      final oldFile = files.firstWhereOrNull((element) => element.id == fileId);
      if (oldFile == null) throw Exception('File not found');

      /// Update file with new questions
      final newFile = oldFile.copyWith(quizzes: questions);
      files[files.indexWhere((element) => element.id == fileId)] = newFile;

      /// Update collection with new files
      final collection = collections[collectionIndex].copyWith(files: files);
      await _collectionService.updateCollection(collection);
    } on Exception catch (e) {
      throw Exception('Failed to store questions: $e');
    }
  }

  @override
  List<QuizModel> getQuestions(String collectionId, String fileId) {
    try {
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) {
        throw Exception('Collection not found');
      }

      return collections[collectionIndex]
              .files
              .firstWhereOrNull((element) => element.id == fileId)
              ?.quizzes ??
          [];
    } on Exception catch (e) {
      throw Exception('Failed to get questions: $e');
    }
  }

  @override
  List<QuizModel> getAllQuestions(String collectionId) {
    try {
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) {
        throw Exception('Collection not found');
      }

      return collections[collectionIndex]
          .files
          .expand((element) => element.quizzes)
          .toList();
    } on Exception catch (e) {
      throw Exception('Failed to get questions: $e');
    }
  }

  @override
  Future<void> resetQuestions(String collectionId) async {
    try {
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) throw Exception('Collection not found');

      for (var file in collections[collectionIndex].files) {
        final resetQuestions = file.quizzes
            .map((e) => QuizModel.initial(
                fileId: file.id, question: e.question, answer: e.answer))
            .toList();

        await storeQuestions(collectionId, file.id, resetQuestions);
      }
    } on Exception catch (e) {
      throw Exception('Failed to reset questions: $e');
    }
  }

  @override
  Future<void> answerQuestion(
    String collectionId,
    String fileId,
    String questionId,
    bool answeredCorrectly,
  ) async {
    try {
      final questions = getAllQuestions(collectionId);
      final questionIndex =
          questions.indexWhere((element) => element.id == questionId);
      if (questionIndex == -1) {
        throw Exception('Question not found');
      }

      final question = questions[questionIndex].copyWith(
        answeredCorrectly: answeredCorrectly,
      );

      questions[questionIndex] = question;

      await storeQuestions(collectionId, fileId,
          questions.where((e) => e.fileId == fileId).toList());
    } on Exception catch (e) {
      throw Exception('Failed to answer question: $e');
    }
  }
}
