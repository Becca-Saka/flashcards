import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_icons.dart';
import 'package:flashcards/shared/app_spacing.dart';
import 'package:flashcards/shared/app_text_style.dart';
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
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(),
              backgroundColor: AppColors.primaryColor,
              onPressed: controller.createCollection,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: controller.collections.isNotEmpty
                ? Center(
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
                  )
                : const SizedBox(),
          );
        });
  }
}
