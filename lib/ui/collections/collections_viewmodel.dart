import 'package:carousel_slider/carousel_controller.dart';
import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:flashcards/data/services/collection_service.dart';
import 'package:flashcards/data/services/file_picker_service.dart';
import 'package:flashcards/model/collection_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../data/services/gemini_services.dart';
import '../../data/services/quiz_service.dart';
import '../../model/collection_file.dart';

class CollectionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FilePickerService _filePickerService = FilePickerService();
  final CarouselController carouselController = CarouselController();
  final _collectionService = locator<ICollectionService>();
  final _geminiService = locator<IGeminiService>();
  final _quizService = locator<IQuizService>();

  int carouselPage = 0;
  List<CollectionModel> get collections => _collectionService.collections;
  CollectionModel? get selectedCollection =>
      _collectionService.currentCollection;

  String? collectionName;
  String? description;

  void createCollection() {
    _dialogService.showCustomDialog(
      variant: DialogType.create,
      barrierDismissible: true,
    );
  }

  void updateCollectionName(String value) {
    collectionName = value;
  }

  void updateDescription(String value) {
    description = value;
  }

  Future<void> saveCollection() async {
    _navigationService.back();
    await _collectionService.createCollection(CollectionModel.initial(
      name: collectionName!,
      description: description!,
    ));
    notifyListeners();
  }

  void viewCollection(CollectionModel collection) {
    _collectionService.currentCollection = collection;
    notifyListeners();
    _navigationService.navigateTo(AppRoutes.collectionDetail);
  }

  Future<void> addFiles([int? selectedIndex]) async {
    final files = await _filePickerService.pickFile();
    if (files == null) return;
    if (files.isEmpty) return;

    int index = selectedIndex ?? collections.indexOf(selectedCollection!);

    await _collectionService.addAssetsToCollection(
      collections[index].uid,
      files
          .map((e) => CollectionFile.initial(name: e.name, path: e.path))
          .toList(),
    );

    if (selectedIndex == null) {
      _collectionService.currentCollection = collections[index];
    }
    notifyListeners();

    /// Generate questions
    final uploadedCollection =
        await _geminiService.uploadCollectionFiles(collections[index]);
    await _collectionService.updateCollection(uploadedCollection);

    /// generate questions
    final questions =
        await _geminiService.generateQuiz(uploadedCollection.files);
    await _quizService.storeQuestions(uploadedCollection.uid, questions);
    notifyListeners();
  }

  Future<void> removeFile(CollectionFile file) async {
    int index = collections.indexOf(selectedCollection!);

    await _collectionService.removeAssetsFromCollection(
      collections[index].uid,
      file,
    );

    _collectionService.currentCollection = collections[index];
    notifyListeners();
  }

  Future<void> startQuiz([CollectionModel? collection]) async {
    _collectionService.currentCollection = collection ?? selectedCollection;
    if (selectedCollection == null) return;
    if (selectedCollection!.quizzes.isEmpty) return;
    if (selectedCollection!.quizzes.any((quiz) => quiz.isAnswered)) {
      _dialogService.showCustomDialog(
        variant: DialogType.quizProgress,
        barrierDismissible: true,
      );
    } else {
      await _navigationService.navigateTo(AppRoutes.quiz);
      _collectionService.currentCollection = _collectionService.collections
          .firstWhere((element) => element.uid == selectedCollection!.uid);
    }
  }

  Future<void> continueQuiz() async {
    _navigationService.back();
    await _navigationService.navigateTo(AppRoutes.quiz);
    _collectionService.currentCollection = _collectionService.collections
        .firstWhere((element) => element.uid == selectedCollection!.uid);
  }

  Future<void> playQuiz() async {
    _navigationService.back();
    await _quizService.resetQuestions(selectedCollection!.uid);
    await _navigationService.navigateTo(AppRoutes.quiz);
    _collectionService.currentCollection = _collectionService.collections
        .firstWhere((element) => element.uid == selectedCollection!.uid);
  }

  void correctAnswer() {
    _quizService.answerQuestion(
      selectedCollection!.uid,
      selectedCollection!.quizzes[carouselPage].id,
      true,
    );
    _movePage();
  }

  void incorrectAnswer() {
    _quizService.answerQuestion(
      selectedCollection!.uid,
      selectedCollection!.quizzes[carouselPage].id,
      false,
    );
    _movePage();
  }

  void _movePage() {
    if (carouselPage == selectedCollection!.quizzes.length - 1) {
      _navigationService.navigateTo(AppRoutes.quizResult);
    } else {
      carouselController.nextPage();
      carouselPage++;
      notifyListeners();
    }
  }
}
