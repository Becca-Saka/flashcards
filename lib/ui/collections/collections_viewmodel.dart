import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CollectionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final collections = [];

  String? collectionName;

  String? description;

  void createCollection() {
    _dialogService.showCustomDialog(
      variant: DialogType.create,
      barrierDismissible: true,
    );
  }

  void updateCollectionName(String value) {}

  void updateDescription(String value) {}
}
