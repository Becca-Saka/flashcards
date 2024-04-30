import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/shared/custom_expansion_tile.dart';
import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSpacing(v: 40),
                    Text(
                      'Question 1 of 5',
                      style: AppTextStyle.extraBold16,
                    ),
                    const AppSpacing(v: 28),
                    CarouselSlider.builder(
                      carouselController: controller.carouselController,
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
                        onPageChanged: (page, reason) {},
                        scrollDirection: Axis.horizontal,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                      ),
                      itemCount: controller.quizzes.length,
                      // shrinkWrap: true,
                      itemBuilder: (context, index, pageindex) {
                        final file = controller.quizzes[index];
                        return Card(
                          color: Colors.primaries[Random().nextInt(18)],
                          child: Container(
                            color: Colors.primaries[Random().nextInt(18)],
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  'Question ${index + 1}',
                                  style: AppTextStyle.medium14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const AppSpacing(v: 20),
                                Text(
                                  file.title,
                                  style: AppTextStyle.extraBold24.copyWith(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                const Spacer(),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
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
                                      Text(
                                        file.answer,
                                        style: AppTextStyle.bold16.copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
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
                          onPressed: controller.incorrectAnswer,
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
                          onPressed: controller.correctAnswer,
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
              ));
        });
  }
}
