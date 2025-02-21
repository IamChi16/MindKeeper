import 'package:flutter/material.dart';
import '../../app/app_export.dart';

extension on TextStyle {
  TextStyle get lato {
    return copyWith(
      fontFamily: 'Lato',
    );
  }
}

class CustomText {
  //Body text style
  static TextStyle get bodyLargeErrorContainer =>
    theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.errorContainer,
  );
  static TextStyle get bodyLargeGray500 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray500,
  );
  static TextStyle get bodyLargeGray40001 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray40001,
  );
  static TextStyle get bodyLargeBluegray70001 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.blueGray70001,
  );
  static TextStyle get bodyLargeWhiteA700 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.whiteA700.withOpacity(0.44),
  );
  static TextStyle get bodyLargeWhiteA7001 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.whiteA700,
  );
  static TextStyle get bodyLargeWhiteA7002 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.whiteA700.withOpacity(0.67),
  );
  static TextStyle get bodyLargeWhiteA7003 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.whiteA700.withOpacity(0.5),
  );

  static TextStyle get bodyMediumWhiteA700 =>
    theme.textTheme.bodyMedium!.copyWith(
      color: appTheme.whiteA700.withOpacity(0.44),
  );

  static TextStyle get bodyMediumWhiteA7001 =>
    theme.textTheme.bodyMedium!.copyWith(
      color: appTheme.whiteA700,
  );
  
  static TextStyle get bodyMediumWhiteA7002 =>
    theme.textTheme.bodyMedium!.copyWith(
      color: appTheme.whiteA700.withOpacity(0.67),
  );

  static TextStyle get bodyLargeBluegray700 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.blueGray700,
  );

  static TextStyle get bodyLargeBluegray400 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.gray400,
  );

  static TextStyle get bodyLargeBluegray600 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.blueGray600,
  );
  static TextStyle get bodyLargeRed500 =>
    theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.red500,
  );

  //Title text style
  static TextStyle get titleLargeBold =>
    theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w700,
  );
  static TextStyle get titleLargeMedium =>
    theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w500,
  );
}