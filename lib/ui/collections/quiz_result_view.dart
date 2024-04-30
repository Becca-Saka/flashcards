import 'package:flashcards/app/locator.dart';
import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class QuizResultView extends StatelessWidget {
  const QuizResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionsViewModel>.reactive(
        viewModelBuilder: () => locator<CollectionsViewModel>(),
        disposeViewModel: false,
        builder: (context, controller, child) {
          return Scaffold(
              appBar: CustomAppBar(
                title: '${controller.selectedCollection?.name}',
                actions: SizedBox(
                  height: 30,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back',
                      style: AppTextStyle.medium14,
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      '👍',
                      style: AppTextStyle.bold16.copyWith(
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      'Good Job',
                      style: AppTextStyle.bold16.copyWith(
                        fontSize: 36,
                      ),
                    ),
                    const AppSpacing(v: 20),
                    Text(
                      'You answered 5 out of 5 questions correctly!',
                      style: AppTextStyle.regular16,
                    ),
                    const Spacer(flex: 2),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppButton(
                          title: '',
                          elevation: 5,
                          height: 60,
                          width: 60,
                          expanded: false,
                          shape: ButtonShape.circle,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          // onPressed: controller.incorrectAnswer,
                          child: AppIcons(
                            icon: AppIconData.previous,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        AppButton(
                          title: '',
                          elevation: 5,
                          height: 80,
                          width: 80,
                          expanded: false,
                          shape: ButtonShape.circle,
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.zero,
                          // onPressed: controller.incorrectAnswer,
                          child: AppIcons(
                            icon: AppIconData.restart,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        AppButton(
                          title: '',
                          elevation: 5,
                          height: 60,
                          width: 60,
                          expanded: false,
                          shape: ButtonShape.circle,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          // onPressed: controller.correctAnswer,
                          child: AppIcons(
                            icon: AppIconData.next,
                            size: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const AppSpacing(v: 60),
                  ],
                ),
              ));
        });
  }
}
