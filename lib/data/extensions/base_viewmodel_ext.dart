import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/locator.dart';
import '../../app/set_up_snackbar_ui.dart';

extension BaseViewModelExtension on BaseViewModel {
  SnackbarService get _snackbarService => locator<SnackbarService>();

  void setBusyForFileUpload(String collectionId, bool value) {
    setBusyForObject('collection/$collectionId/loading-gemini', value);
  }

  bool busyForFileUpload(String collectionId) {
    return busy('collection/$collectionId/loading-gemini');
  }

  void showErrorSnackbar([String? message]) {
    _snackbarService.showCustomSnackBar(
      variant: SnackbarType.error,
      message: message ?? "Something went wrong",
      duration: const Duration(seconds: 3),
    );
    notifyListeners();
  }
}
