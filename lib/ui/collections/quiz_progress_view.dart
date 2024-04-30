import 'package:flashcards/shared/app_button.dart';
import 'package:flashcards/shared/app_spacing.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class QuizProgresView extends StatelessWidget {
  const QuizProgresView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionsViewModel>.reactive(
        viewModelBuilder: () => CollectionsViewModel(),
        builder: (context, controller, child) {
          return Dialog(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50.0),
                  Text(
                    'Would you like to continue from your saved progress?',
                    style: AppTextStyle.semibold14.copyWith(fontSize: 18),
                  ),
                  const AppSpacing(v: 30),
                  AppButton(
                    title: 'Yes, continue',
                    isLoading: controller.isBusy,
                    textColor: Colors.white,
                    onPressed: controller.playQuiz,
                  ),
                  const AppSpacing(v: 20),
                  AppButton.outlined(
                    title: 'No, start again',
                    isLoading: controller.isBusy,
                    onPressed: controller.continueQuiz,
                  ),
                  const AppSpacing(v: 16),
                ],
              ),
            ),
          );
        });
  }
}
