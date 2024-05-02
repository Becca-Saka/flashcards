import 'package:dotted_border/dotted_border.dart';
import 'package:flashcards/shared/shared.dart';
import 'package:flashcards/ui/collections/widgets/play_icon.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class CollectionView extends StatelessWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionsViewModel>.reactive(
      viewModelBuilder: () => CollectionsViewModel(),
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
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.selectedCollection != null &&
                  controller.selectedCollection!.files.isNotEmpty)
                FloatingActionButton(
                  elevation: 0,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryColor,
                  onPressed: controller.addFiles,
                  child: const AppIcons(
                    icon: AppIconData.save,
                    color: Colors.white,
                  ),
                ),
              const AppSpacing(v: 30),
              if (controller.selectedCollection != null &&
                  controller.selectedCollection!.quizzes.isNotEmpty)
                FloatingActionButton(
                  elevation: 0,
                  heroTag: null,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.black100,
                  onPressed: controller.startQuiz,
                  child: const PlayIcon(),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: controller.selectedCollection == null ||
                    controller.selectedCollection!.files.isEmpty
                ? Center(
                    child: InkWell(
                      onTap: controller.addFiles,
                      child: DottedBorder(
                        color: const Color(0xFF999999),
                        dashPattern: const [6, 6],
                        radius: const Radius.circular(6),
                        borderType: BorderType.RRect,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppSpacing(v: 10),
                              const AppIcons(
                                icon: AppIconData.upload,
                                color: AppColors.black100,
                                size: 80,
                              ),
                              const AppSpacing(v: 8),
                              Text(
                                'Upload files here',
                                style: AppTextStyle.semibold14,
                              ),
                              const AppSpacing(v: 4),
                              Text(
                                'Pdf or Png images only',
                                style: AppTextStyle.regular10.copyWith(
                                  fontSize: 8,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const AppSpacing(v: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacing(v: 30),
                      Text(
                        'Sources',
                        style: AppTextStyle.extraBold16,
                      ),
                      const AppSpacing(v: 20),
                      ListView.builder(
                        itemCount: controller.selectedCollection!.files.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final file =
                              controller.selectedCollection!.files[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              color: const Color(0xFFFAFAFA),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      file.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.regular14,
                                    ),
                                  ),
                                  AppIcons(
                                    icon: AppIconData.delete,
                                    size: 20,
                                    onTap: () => controller.removeFile(file),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
