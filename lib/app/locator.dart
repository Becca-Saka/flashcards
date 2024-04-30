import 'package:flashcards/data/services/collection_service.dart';
import 'package:flashcards/data/services/local_storage_service.dart';
import 'package:flashcards/ui/auth/user_view_model.dart';
import 'package:flashcards/ui/collections/collections_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../data/services/gemini_services.dart';
import '../data/services/quiz_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<UserViewModel>(() => UserViewModel());
  locator.registerLazySingleton<CollectionsViewModel>(
      () => CollectionsViewModel());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<ILocalStorage>(() => LocalStorageService());
  locator.registerLazySingleton<ICollectionService>(() => CollectionService());
  locator.registerLazySingleton<IGeminiService>(() => GeminiService());
  locator.registerLazySingleton<IQuizService>(() => QuizService());
}
