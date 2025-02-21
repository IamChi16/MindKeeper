import 'package:flutter/material.dart';
import '../../app/app_export.dart';

class CustomButton {
  static ButtonStyle get fillIndigo4 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.indigo300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get roundPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryFixed,
        side: BorderSide(color: theme.colorScheme.primaryFixed),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get error => ElevatedButton.styleFrom(
        backgroundColor: appTheme.red500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  //Outline button style
  static ButtonStyle get outlineIndigoA => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: appTheme.indigoA100, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.zero,
      );
  //text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.transparent)),
      );

  static ButtonStyle get normal => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 25, 20, 29)),
        elevation: WidgetStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Color.fromARGB(255, 25, 20, 29))),
      );

  static ButtonStyle get underlineGray500 => TextButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.zero,
        textStyle: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.grey[500],
        ),
      );
}
