import 'package:stacked/stacked.dart';

extension BaseViewModelExtension on BaseViewModel {
  void setBusyForFileUpload(String collectionId, bool value) {
    setBusyForObject('collection/$collectionId/loading-gemini', value);
  }

  bool busyForFileUpload(String collectionId) {
    return busy('collection/$collectionId/loading-gemini');
  }
}
