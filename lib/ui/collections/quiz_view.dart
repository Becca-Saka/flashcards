import 'package:carousel_slider/carousel_slider.dart';
import 'package:flashcards/model/quiz_model.dart';
import 'package:flashcards/shared/custom_expansion_tile.dart';
import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class QuizView extends HookWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final carouselController = CarouselController();
    final page = useValueNotifier(0);
    final colors = [...Colors.primaries]..shuffle();
    return ViewModelBuilder<CollectionsViewModel>.reactive(
      viewModelBuilder: () => CollectionsViewModel(),
      onViewModelReady: (viewModel) => viewModel.initQuiz(carouselController),
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
                const AppSpacing(v: 40),
                Text(
                  'Question ${controller.carouselPage + 1} of ${controller.currentQuiz.length}',
                  style: AppTextStyle.extraBold16,
                ),
                const AppSpacing(v: 28),
                CarouselSlider.builder(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 380,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: (index, _) => page.value = index,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                  itemCount: controller.currentQuiz.length,
                  // shrinkWrap: true,
                  itemBuilder: (context, index, pageindex) {
                    final file = controller.currentQuiz[index];
                    final color = colors[index];
                    return QuestionCard(file: file, index: index, color: color);
                  },
                ),
                const AppSpacing(v: 40),
                Text(
                  'Did you get the answer?',
                  style: AppTextStyle.semibold14.copyWith(
                    fontSize: 16,
                  ),
                ),
                const AppSpacing(v: 51),
                Row(
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
                      onPressed: () => controller.answerQuiz(carouselController,
                          controller.currentQuiz[page.value], false),
                      child: const AppIcons(
                        icon: AppIconData.cancel,
                        size: 20,
                        color: Colors.red,
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
                      onPressed: () => controller.answerQuiz(carouselController,
                          controller.currentQuiz[page.value], true),
                      child: const AppIcons(
                        icon: AppIconData.check,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.file,
    required this.index,
    required this.color,
  });

  final QuizModel file;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        color: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}',
                    style: AppTextStyle.medium14.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const AppSpacing(v: 20),
                  Flexible(
                    child: Text(
                      file.question,
                      style: AppTextStyle.extraBold24.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: CustomExpansionTile(
                childrenPadding: EdgeInsets.zero,
                tilePadding: EdgeInsets.zero,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Text(
                  'Show answer',
                  style: AppTextStyle.bold16.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                collapsedTitle: Text(
                  'Hide answer',
                  style: AppTextStyle.bold16.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.2,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        file.answer,
                        style: AppTextStyle.bold16.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
