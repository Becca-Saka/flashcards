import 'package:flashcards/shared/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static const String fontFamily = 'Manrope';

  /// Base text style
  static const TextStyle _baseTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: AppFontWeight.regular,
    letterSpacing: -0.3,
    color: AppColors.black100,
  );

  ///Manrope 10
  static TextStyle get regular10 => _baseTextStyle.copyWith(fontSize: 10);

  ///Manrope medium 10
  static TextStyle get medium10 =>
      regular10.copyWith(fontWeight: AppFontWeight.medium);

  ///Manrope bold 10
  static TextStyle get semiBold10 =>
      regular10.copyWith(fontWeight: AppFontWeight.semiBold);

  ///Manrope 12
  static TextStyle get regular12 => _baseTextStyle.copyWith(fontSize: 12);

  ///Manrope medium 14
  static TextStyle get medium14 => regular10.copyWith(
        fontWeight: AppFontWeight.medium,
        fontSize: 14,
      );

  ///Manrope 14
  static TextStyle get regular14 => _baseTextStyle.copyWith(fontSize: 14);

  ///Manrope light 14
  static TextStyle get light14 =>
      regular14.copyWith(fontWeight: AppFontWeight.light);

  ///Manrope bold 14
  static TextStyle get semibold14 =>
      regular16.copyWith(fontWeight: AppFontWeight.semiBold);

  ///Manrope 16
  static TextStyle get regular16 => _baseTextStyle.copyWith(fontSize: 16);

  ///Manrope medium 16
  static TextStyle get medium16 => regular10.copyWith(
        fontWeight: AppFontWeight.medium,
        fontSize: 16,
      );

  ///Manrope bold 16
  static TextStyle get bold16 =>
      regular16.copyWith(fontWeight: AppFontWeight.bold);

  ///Manrope bold 16
  static TextStyle get extraBold16 => regular16.copyWith(
        fontWeight: AppFontWeight.extraBold,
      );

  ///Manrope  24
  static TextStyle get regular24 => _baseTextStyle.copyWith(fontSize: 24);

  ///Manrope bold 24
  static TextStyle get semibold24 =>
      regular24.copyWith(fontWeight: AppFontWeight.semiBold);

  ///Manrope bold 24
  static TextStyle get extraBold24 =>
      regular24.copyWith(fontWeight: AppFontWeight.extraBold);
}

abstract class AppFontWeight {
  /// FontWeight value of `w900`
  static const FontWeight black = FontWeight.w900;

  /// FontWeight value of `w800`
  static const FontWeight extraBold = FontWeight.w800;

  /// FontWeight value of `w700`
  static const FontWeight bold = FontWeight.w700;

  /// FontWeight value of `w600`
  static const FontWeight semiBold = FontWeight.w600;

  /// FontWeight value of `w500`
  static const FontWeight medium = FontWeight.w500;

  /// FontWeight value of `w400`
  static const FontWeight regular = FontWeight.w400;

  /// FontWeight value of `w300`
  static const FontWeight light = FontWeight.w300;

  /// FontWeight value of `w200`
  static const FontWeight extraLight = FontWeight.w200;

  /// FontWeight value of `w100`
  static const FontWeight thin = FontWeight.w100;
}
