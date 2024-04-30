import 'package:flashcards/app/locator.dart';
import 'package:flashcards/ui/collections/create_collections_view.dart';
import 'package:flashcards/ui/collections/quiz_progress_view.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType { create, quizProgress }

void setupDialogUi() {
  final service = locator<DialogService>();
  service.registerCustomDialogBuilders({
    DialogType.create: (context, request, completer) => CreateCollectionView(),
    DialogType.quizProgress: (context, request, completer) => QuizProgresView()
  });
}
