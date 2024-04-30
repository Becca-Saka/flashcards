import 'package:carousel_slider/carousel_controller.dart';
import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:flashcards/data/services/collection_service.dart';
import 'package:flashcards/data/services/file_picker_service.dart';
import 'package:flashcards/model/collection_model.dart';
import 'package:flashcards/model/quiz_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../model/collection_file.dart';

class CollectionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FilePickerService _filePickerService = FilePickerService();
  final CarouselController carouselController = CarouselController();
  final _collectionService = locator<ICollectionService>();

  int carouselPage = 0;
  List<CollectionModel> get collections => _collectionService.collections;

  final List<QuizModel> quizzes = [
    QuizModel(
      title: 'What is 1 + 1?',
      answer: '2',
    ),
    QuizModel(
      title: 'Who is the creator of Flutter?',
      answer: 'Google',
    ),
    QuizModel(
      title: 'What is Flutter?',
      answer: 'A framework',
    ),
    QuizModel(
      title: 'What is type?',
      answer: 'A framework',
    ),
  ];
  CollectionModel? selectedCollection;
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
    selectedCollection = collection;
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
      selectedCollection = collections[index];
    }
    notifyListeners();
  }

  Future<void> removeFile(CollectionFile file) async {
    int index = collections.indexOf(selectedCollection!);

    await _collectionService.removeAssetsFromCollection(
      collections[index].uid,
      file,
    );

    selectedCollection = collections[index];
    notifyListeners();
  }

  void startQuiz([CollectionModel? collection]) {
    selectedCollection = collection ?? selectedCollection;
    _dialogService.showCustomDialog(
      variant: DialogType.quizProgress,
      barrierDismissible: true,
    );
  }

  void continueQuiz() {
    _navigationService.back();
    _navigationService.navigateTo(AppRoutes.quiz);
  }

  void playQuiz() {
    _navigationService.back();
    _navigationService.navigateTo(AppRoutes.quiz);
  }

  void correctAnswer() {
    _movePage();
  }

  void incorrectAnswer() {
    _movePage();
  }

  void _movePage() {
    if (carouselPage == quizzes.length - 1) {
      _navigationService.navigateTo(AppRoutes.quizResult);
    } else {
      carouselController.nextPage();
      carouselPage++;
      notifyListeners();
    }
  }
}
