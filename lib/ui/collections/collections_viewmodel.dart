import 'package:carousel_slider/carousel_controller.dart';
import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:flashcards/data/extensions/base_viewmodel_ext.dart';
import 'package:flashcards/data/services/collection_service.dart';
import 'package:flashcards/data/services/file_picker_service.dart';
import 'package:flashcards/model/collection_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/set_up_snackbar_ui.dart';
import '../../data/services/gemini_services.dart';
import '../../data/services/quiz_service.dart';
import '../../model/collection_file.dart';

class CollectionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FilePickerService _filePickerService = FilePickerService();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final _collectionService = locator<ICollectionService>();
  final _geminiService = locator<IGeminiService>();
  final _quizService = locator<IQuizService>();
  final _log = Logger();

  int carouselPage = 0;
  List<CollectionModel> get collections => _collectionService.collections;
  CollectionModel? get selectedCollection =>
      _collectionService.currentCollection;

  String? collectionName;
  String? description;

  Future<void> createCollection() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.create,
      barrierDismissible: true,
    );
    notifyListeners();
  }

  void updateCollectionName(String value) => collectionName = value;

  void updateDescription(String value) => description = value;

  Future<void> saveCollection() async {
    await _collectionService.createCollection(CollectionModel.initial(
      name: collectionName!,
      description: description!,
    ));
    _navigationService.back();
    notifyListeners();
  }

  Future<void> viewCollection(CollectionModel collection) async {
    _collectionService.currentCollection = collection;
    await _navigationService.navigateTo(AppRoutes.collectionDetail);
    _collectionService.currentCollection = null;
    notifyListeners();
  }

  Future<void> addFiles([int? selectedIndex]) async {
    int index = selectedIndex ?? collections.indexOf(selectedCollection!);
    if (index == -1) return;
    try {
      final files = await _filePickerService.pickFile();
      if (files == null) return;
      if (files.isEmpty) return;

      await _collectionService.addAssetsToCollection(
        collections[index].uid,
        files
            .map((e) => CollectionFile.initial(name: e.name, path: e.path))
            .toList(),
      );
      notifyListeners();

      setBusyForFileUpload(collections[index].uid, true);

      /// Generate questions
      final uploadedCollection =
          await _geminiService.uploadCollectionFiles(collections[index]);
      await _collectionService.updateCollection(uploadedCollection);

      /// generate questions
      final questions =
          await _geminiService.generateQuiz(uploadedCollection.files);
      await _quizService.storeQuestions(uploadedCollection.uid, questions);
    } on Exception catch (e) {
      _log.e(e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
        duration: const Duration(seconds: 3),
      );
    } finally {
      setBusyForFileUpload(collections[index].uid, false);
      notifyListeners();
    }
  }

  Future<void> removeFile(CollectionFile file) async {
    if (selectedCollection == null) return;

    int index = collections.indexOf(selectedCollection!);
    if (index == -1) return;

    await _collectionService.removeAssetsFromCollection(
      collections[index].uid,
      file,
    );
    notifyListeners();
  }

  Future<void> startQuiz([CollectionModel? collection]) async {
    final coll = collection ?? selectedCollection;
    if (coll == null) return;
    if (coll.quizzes.isEmpty) return;
    if (coll.quizzes.any((quiz) => quiz.isAnswered)) {
      final res = await _dialogService.showCustomDialog(
        variant: DialogType.quizProgress,
        barrierDismissible: true,
      );
      if (res == null) return;
      final shouldReset = res.confirmed;
      await openQuiz(collection: coll, shouldReset: shouldReset);
    } else {
      await openQuiz(collection: coll);
    }
  }

  Future<void> openQuiz({
    required CollectionModel collection,
    bool shouldReset = false,
  }) async {
    if (shouldReset) {
      await _quizService.resetQuestions(collection.uid);
    }
    if (_collectionService.currentCollection != null) {
      await _navigationService.navigateTo(AppRoutes.quiz);
      return;
    }
    _collectionService.currentCollection = collection;
    await _navigationService.navigateTo(AppRoutes.quiz);
    _collectionService.currentCollection = null;
    notifyListeners();
  }

  void answerQuiz(CarouselController carouselController, bool isCorrect) {
    _quizService.answerQuestion(
      selectedCollection!.uid,
      selectedCollection!.quizzes[carouselPage].id,
      isCorrect,
    );
    _movePage(carouselController);
  }

  void _movePage(CarouselController carouselController) {
    if (carouselPage == selectedCollection!.quizzes.length - 1) {
      _navigationService.navigateTo(AppRoutes.quizResult);
    } else {
      carouselController.nextPage();
      carouselPage++;
      notifyListeners();
    }
  }

  void initQuiz(CarouselController carouselController) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (selectedCollection != null &&
          selectedCollection!.quizzes.any((quiz) => !quiz.isAnswered)) {
        final index =
            selectedCollection!.quizzes.indexWhere((quiz) => !quiz.isAnswered);
        carouselController.jumpToPage(index);
        carouselPage = index;
        notifyListeners();
      }
    });
  }

  void restartQuiz() {
    try {
      final collection = selectedCollection!;
      _navigationService.popRepeated(2);
      openQuiz(collection: collection, shouldReset: true);
    } on Exception catch (e) {
      _log.e(e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
        duration: const Duration(seconds: 3),
      );
    }
  }
}
