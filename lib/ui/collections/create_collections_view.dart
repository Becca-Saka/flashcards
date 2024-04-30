import 'package:flashcards/shared/app_button.dart';
import 'package:flashcards/shared/app_input.dart';
import 'package:flashcards/shared/app_spacing.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flashcards/shared/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collections_viewmodel.dart';

class CreateCollectionView extends StatelessWidget {
  CreateCollectionView({super.key});

  final GlobalKey<FormState> collectionFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionsViewModel>.reactive(
        viewModelBuilder: () => CollectionsViewModel(),
        builder: (context, controller, child) {
          return Dialog(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Form(
                  key: collectionFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50.0),
                      Text(
                        'Add To Collection',
                        style: AppTextStyle.extraBold24,
                      ),
                      const AppSpacing(v: 30),
                      AppInput(
                        hintText: 'Enter collection name',
                        initialValue: controller.collectionName,
                        onChanged: controller.updateCollectionName,
                        validator: AppValidators.validateField,
                      ),
                      const AppSpacing(v: 15),
                      AppInput(
                        hintText: 'Enter description',
                        maxLines: 4,
                        initialValue: controller.description,
                        onChanged: controller.updateDescription,
                        validator: AppValidators.validateField,
                      ),
                      const AppSpacing(v: 33),
                      AppButton(
                        title: 'Sign In',
                        isLoading: controller.isBusy,
                        textColor: Colors.white,
                        onPressed: () {
                          if (collectionFormKey.currentState == null) return;
                          if (collectionFormKey.currentState!.validate()) {
                            controller.saveCollection();
                          }
                        },
                      ),
                      const AppSpacing(v: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
