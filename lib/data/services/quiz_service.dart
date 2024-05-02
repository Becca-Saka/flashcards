import 'package:flashcards/app/locator.dart';

import '../../model/quiz_model.dart';
import 'collection_service.dart';

abstract class IQuizService {
  Future<void> storeQuestions(
    String collectionId,
    List<QuizModel> questions,
  );

  List<QuizModel> getQuestions(String collectionId);

  Future<void> resetQuestions(String collectionId);

  Future<void> answerQuestion(
    String collectionId,
    String questionId,
    bool answeredCorrectly,
  );
}

class QuizService extends IQuizService {
  final _collectionService = locator<ICollectionService>();

  @override
  Future<void> storeQuestions(
    String collectionId,
    List<QuizModel> questions,
  ) async {
    try {
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) {
        throw Exception('Collection not found');
      }

      final collection = collections[collectionIndex].copyWith(
          quizzes: collections[collectionIndex].quizzes..addAll(questions));

      await _collectionService.updateCollection(collection);
    } on Exception catch (e) {
      throw Exception('Failed to store questions: $e');
    }
  }

  @override
  List<QuizModel> getQuestions(String collectionId) {
    try {
      var collections = _collectionService.collections;
      final collectionIndex =
          collections.indexWhere((element) => element.uid == collectionId);
      if (collectionIndex == -1) {
        throw Exception('Collection not found');
      }

      return collections[collectionIndex].quizzes;
    } on Exception catch (e) {
      throw Exception('Failed to get questions: $e');
    }
  }

  @override
  Future<void> resetQuestions(String collectionId) async {
    try {
      final questions = getQuestions(collectionId);
      final resetQuestions = questions
          .map((e) => QuizModel.initial(question: e.question, answer: e.answer))
          .toList();

      return await storeQuestions(collectionId, resetQuestions);
    } on Exception catch (e) {
      throw Exception('Failed to reset questions: $e');
    }
  }

  @override
  Future<void> answerQuestion(
    String collectionId,
    String questionId,
    bool answeredCorrectly,
  ) async {
    try {
      final questions = getQuestions(collectionId);
      final questionIndex =
          questions.indexWhere((element) => element.id == questionId);
      if (questionIndex == -1) {
        throw Exception('Question not found');
      }

      final question = questions[questionIndex].copyWith(
        answeredCorrectly: answeredCorrectly,
      );

      questions[questionIndex] = question;

      await storeQuestions(collectionId, questions);
    } on Exception catch (e) {
      throw Exception('Failed to answer question: $e');
    }
  }
}
