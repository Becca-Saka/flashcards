import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_snackbar_ui.dart';
import 'package:flashcards/data/services/firebase_service.dart';
import 'package:flashcards/model/exceptions/auth_exception.dart';
import 'package:flashcards/model/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserViewModel extends BaseViewModel {
  static String googleKey = 'Google';
  UserModel? currentUser;
  final FirebaseService _firebaseService = FirebaseService();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  bool get isGoogleBusy => busy(UserViewModel.googleKey);
  String? firstName;

  String? lastName;

  String? password;

  String? confirmPassword;

  String? email;
  int currentIndex = 1;

  void updateEmail(String value) {
    email = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  void updateFirstName(String value) {
    firstName = value;
  }

  void updateLastName(String value) {
    lastName = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
  }

  Future<void> createAccount() async {
    try {
      setBusy(true);
      final response = await _firebaseService.createAccount(
          email!, password!, firstName!, lastName!);
      setBusy(false);
      notifyListeners();
      if (response) {
        _snackbarService.showCustomSnackBar(
          variant: SnackbarType.success,
          message: 'Account created, you can now sign in',
          duration: const Duration(seconds: 3),
        );
        _navigationService.clearStackAndShow(AppRoutes.signIn);
      }
    } on AuthException catch (e) {
      _showErrorSnackbar(e.message);
      setBusy(false);
    } on Exception catch (_) {
      _showErrorSnackbar('An error occurred, please try again');
      setBusy(false);
    }
  }

  Future<void> onSignIn() async {
    try {
      setBusy(true);
      final response = await _firebaseService.signIn(email!, password!);
      if (response != null) {
        currentUser = response;
        _navigationService.clearStackAndShow(AppRoutes.dashboard);
      }
      setBusy(false);
    } on AuthException catch (e) {
      _showErrorSnackbar(e.message);
      setBusy(false);
    } on Exception catch (_) {
      _showErrorSnackbar('An error occurred, please try again');
      setBusy(false);
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      setBusyForObject(UserViewModel.googleKey, true);
      currentUser = await _firebaseService.logInWithGoogleUser();
      if (currentUser != null) {
        _navigationService.clearStackAndShow(AppRoutes.dashboard);
      }
      setBusyForObject(UserViewModel.googleKey, false);
    } on AuthException catch (e) {
      _showErrorSnackbar(e.message);
      setBusyForObject(UserViewModel.googleKey, false);
    } on Exception catch (_) {
      _showErrorSnackbar('An error occurred, please try again');
      setBusyForObject(UserViewModel.googleKey, false);
    }
  }

  void _showErrorSnackbar(String message) {
    _snackbarService.showCustomSnackBar(
      variant: SnackbarType.error,
      message: message,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = _firebaseService.currentUser;
      if (user != null) {
        currentUser = await _firebaseService.getCurrentUserData();
        _navigationService.clearStackAndShow(AppRoutes.dashboard);
      } else {
        _navigationService.clearStackAndShow(AppRoutes.signIn);
      }
    } on Exception catch (_) {
      _navigationService.clearStackAndShow(AppRoutes.signIn);
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();

    _navigationService.clearStackAndShow(AppRoutes.signIn);
  }

  void navigateForgotPassword() =>
      _navigationService.navigateTo(AppRoutes.forgotPassword);

  void navigateToSignin() {
    _navigationService.back();
  }

  void navigateToSignUp() => _navigationService.navigateTo(AppRoutes.signUp);

  void onItemTap(int index) {
    if (index == 0) {
      signOut();
    } else {
      currentIndex = index;
      notifyListeners();
    }
  }
}
