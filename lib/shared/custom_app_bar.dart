// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });
  final String title;
  final Widget? actions;
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(87 + MediaQuery.of(context).viewPadding.top),
      child: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.black100.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyle.extraBold16.copyWith(
                    fontSize: 20,
                  ),
                ),
                if (actions != null) actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(87 + window.viewPadding.top);
}
