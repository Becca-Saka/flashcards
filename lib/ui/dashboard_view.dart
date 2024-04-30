import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_icons.dart';
import 'package:flashcards/ui/account/account_view.dart';
import 'package:flashcards/ui/auth/user_view_model.dart';
import 'package:flashcards/ui/collections/all_collections_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});
  final screens = [
    const AllCollectionView(),
    const AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(),
        builder: (context, controller, child) {
          return Scaffold(
              body: screens[controller.currentIndex - 1],
              bottomNavigationBar: SizedBox(
                child: BottomNavigationBar(
                  // elevation: 60,

                  onTap: controller.onItemTap,
                  currentIndex: controller.currentIndex,
                  unselectedItemColor: AppColors.black100,
                  selectedItemColor: AppColors.primaryColor,
                  items: [
                    const BottomNavigationBarItem(
                      icon: AppIcons(
                        icon: AppIconData.goBack,
                        size: 24,
                      ),
                      label: 'Sign out',
                    ),
                    BottomNavigationBarItem(
                      icon: AppIcons(
                        icon: AppIconData.collection,
                        size: 24,
                        color: controller.currentIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.black100,
                      ),
                      label: 'Collections',
                    ),
                    BottomNavigationBarItem(
                      icon: AppIcons(
                        icon: AppIconData.user,
                        size: 24,
                        color: controller.currentIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.black100,
                      ),
                      label: 'Account',
                    ),
                  ],
                ),
              ));
        });
  }
}
