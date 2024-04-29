import '../../model/question_model.dart';
import 'local_storage_service.dart';

abstract class IQuestionsService {
  Future<void> storeQuestions(
    String collectionId,
    List<QuestionModel> questions,
  );

  List<QuestionModel> getQuestions(String collectionId);

  Future<void> answerQuestion(
    String collectionId,
    String questionId,
    bool answeredCorrectly,
  );
}

class QuestionsService extends IQuestionsService {
  final ILocalStorage _localStorage = LocalStorageService();

  @override
  Future<void> storeQuestions(
    String collectionId,
    List<QuestionModel> questions,
  ) async {
    try {
      await _localStorage.add(
        StorageKeys.questions(collectionId),
        value: questions.map((e) => e.toMap()).toList(),
      );
    } on Exception catch (e) {
      throw Exception('Failed to store questions: $e');
    }
  }

  @override
  List<QuestionModel> getQuestions(String collectionId) {
    try {
      var questions = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.questions(collectionId),
        def: [],
      );
      questions ??= [];
      return questions.map((e) => QuestionModel.fromMap(e)).toList();
    } on Exception catch (e) {
      throw Exception('Failed to get questions: $e');
    }
  }

  @override
  Future<void> answerQuestion(
    String collectionId,
    String questionId,
    bool answeredCorrectly,
  ) async {
    try {
      var questions = _localStorage.get<List<Map<String, dynamic>>>(
        StorageKeys.questions(collectionId),
        def: [],
      );
      questions ??= [];
      final parsedQuestions =
          questions.map((e) => QuestionModel.fromMap(e)).toList();

      final questionIndex =
          parsedQuestions.indexWhere((element) => element.id == questionId);
      if (questionIndex == -1) {
        throw Exception('Question not found');
      }

      final updatedQuestion =
          parsedQuestions[questionIndex].answerQuestion(answeredCorrectly);
      parsedQuestions[questionIndex] = updatedQuestion;

      await _localStorage.add(
        StorageKeys.questions(collectionId),
        value: parsedQuestions.map((e) => e.toMap()).toList(),
      );
    } on Exception catch (e) {
      throw Exception('Failed to answer question: $e');
    }
  }
}
