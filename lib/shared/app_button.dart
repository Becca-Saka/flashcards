// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_spacing.dart';
import 'package:flutter/material.dart';

import 'app_text_style.dart';

enum ButtonShape {
  rounded,
  circle,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color backgroundColor;
  final bool isLoading;
  final Widget? child;
  final bool expanded;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? outlinedColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? prefix;
  final ButtonShape shape;
  final double? elevation;
  const AppButton({
    super.key,
    this.onPressed,
    required this.title,
    this.backgroundColor = AppColors.primaryColor,
    this.shape = ButtonShape.rounded,
    this.isLoading = false,
    this.child,
    this.expanded = true,
    this.padding,
    this.width,
    this.height,
    this.outlinedColor,
    this.textColor,
    this.textStyle,
    this.prefix,
    this.elevation,
  });

  factory AppButton.outlined({
    VoidCallback? onPressed,
    required String title,
    Color? outlinedColor,
    bool isLoading = false,
    Widget? child,
    Widget? prefix,
    bool expanded = true,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? textColor,
    TextStyle? textStyle,
    ButtonShape shape = ButtonShape.rounded,
  }) {
    return AppButton(
      onPressed: onPressed,
      title: title,
      backgroundColor: Colors.white,
      isLoading: isLoading,
      expanded: expanded,
      padding: padding,
      width: width,
      height: height,
      outlinedColor: outlinedColor ?? AppColors.black50,
      textColor: textColor,
      shape: shape,
      prefix: prefix,
      textStyle: textStyle,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: expanded ? double.infinity : width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          elevation: elevation ?? 0,
          backgroundColor: backgroundColor,
          surfaceTintColor: backgroundColor,
          shadowColor: Colors.white,
          shape: shape == ButtonShape.circle
              ? CircleBorder(
                  side: BorderSide(color: outlinedColor ?? Colors.transparent),
                )
              : RoundedRectangleBorder(
                  side: BorderSide(
                    color: outlinedColor ?? Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? CircularProgressIndicator(
                color: outlinedColor != null
                    ? AppColors.primaryColor
                    : Colors.white,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefix != null) const AppSpacing(h: 30),
                  if (prefix != null) prefix!,
                  if (prefix != null) const Spacer(flex: 1),
                  child ??
                      Text(
                        title,
                        style: textStyle ??
                            AppTextStyle.bold16.copyWith(
                              color: textColor ??
                                  (outlinedColor != null
                                      ? AppColors.black50
                                      : null),
                            ),
                      ),
                  if (prefix != null) const Spacer(flex: 2),
                ],
              ),
      ),
    );
  }
}
