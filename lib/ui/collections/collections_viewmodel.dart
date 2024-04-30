import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:flashcards/data/services/file_picker_service.dart';
import 'package:flashcards/model/collection_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CollectionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FilePickerService _filePickerService = FilePickerService();
  final List<CollectionModel> collections = [
    CollectionModel(
      name: 'Physics 101',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla euismod, nisl eget aliquam',
    )
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

  void saveCollection() {
    _navigationService.back();
    collections.add(CollectionModel(
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

  // Future<void> addFiles() async {
  //   final files = await _filePickerService.pickFile();
  //   if (files != null) {
  //     int index = collections.indexOf(selectedCollection!);
  //     selectedCollection = selectedCollection!.copyWith(
  //       files: [
  //         ...selectedCollection!.files!,
  //         ...files.map((e) => CollectionFile(name: e.name, path: e.path)),
  //       ],
  //     );
  //     collections[index] = selectedCollection!;
  //     notifyListeners();
  //   }
  // }

  Future<void> addFiles([int? selectedIndex]) async {
    final files = await _filePickerService.pickFile();
    if (files != null) {
      int index = selectedIndex ?? collections.indexOf(selectedCollection!);

      collections[index] = collections[index].copyWith(
        files: [
          ...selectedCollection!.files!,
          ...files.map((e) => CollectionFile(name: e.name, path: e.path)),
        ],
      );
      if (selectedIndex == null) {
        selectedCollection = collections[index];
      }
      notifyListeners();
    }
  }

  void removeFile(CollectionFile file) {
    int index = collections.indexOf(selectedCollection!);
    selectedCollection = selectedCollection!.copyWith(
      files: selectedCollection!.files!
          .where((element) => element.path != file.path)
          .toList(),
    );
    collections[index] = selectedCollection!;
    notifyListeners();
  }

  void playQuiz() {}
}
