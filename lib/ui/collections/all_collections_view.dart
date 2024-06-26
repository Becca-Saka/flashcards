import 'package:flashcards/app/locator.dart';
import 'package:flashcards/data/extensions/base_viewmodel_ext.dart';
import 'package:flashcards/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';
import 'widgets/play_icon.dart';

class AllCollectionView extends StatelessWidget {
  const AllCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionsViewModel>.reactive(
      viewModelBuilder: () => locator<CollectionsViewModel>(),
      disposeViewModel: false,
      builder: (context, controller, child) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Collections',
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            shape: const CircleBorder(),
            backgroundColor: AppColors.primaryColor,
            onPressed: controller.createCollection,
            child: const AppIcons(
              icon: AppIconData.add,
              size: 20,
              color: Colors.white,
            ),
          ),
          body: Builder(builder: (context) {
            if (controller.collections.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcons(
                      icon: AppIconData.empty,
                      color: AppColors.black50.withOpacity(0.5),
                      size: 100,
                    ),
                    const AppSpacing(v: 20),
                    Text(
                      'Your collection is empty! Create one',
                      style: AppTextStyle.medium16,
                    )
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0)
                  .copyWith(top: 30),
              child: ListView.builder(
                itemCount: controller.collections.length,
                itemBuilder: (context, index) {
                  final collection = controller.collections[index];
                  final isGeminiLoading =
                      controller.busyForFileUpload(collection.uid);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => controller.viewCollection(collection),
                      child: Container(
                        color: const Color(0xFFFAFAFA),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    collection.name,
                                    style: AppTextStyle.extraBold16,
                                  ),
                                  const AppSpacing(v: 5),
                                  Text(
                                    collection.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.regular10,
                                  ),
                                ],
                              ),
                            ),
                            if (collection.files
                                    .any((e) => e.quizzes.isNotEmpty) ||
                                isGeminiLoading)
                              InkWell(
                                onTap: () => controller.startQuiz(collection),
                                child: Column(
                                  children: [
                                    PlayIcon(isLoading: isGeminiLoading),
                                    if (!isGeminiLoading) ...[
                                      const AppSpacing(v: 4),
                                      Text(
                                        '${collection.files.expand((e) => e.quizzes).length} Questions',
                                        style: AppTextStyle.semiBold10,
                                      ),
                                    ]
                                  ],
                                ),
                              )
                            else
                              InkWell(
                                onTap: () => controller.addFiles(index),
                                child: Column(
                                  children: [
                                    const AppIcons(
                                      icon: AppIconData.upload,
                                      size: 20,
                                    ),
                                    const AppSpacing(v: 4),
                                    Text(
                                      'Upload Files',
                                      style: AppTextStyle.semiBold10,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
}
