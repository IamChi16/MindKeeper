import 'package:flutter/material.dart';
import '../../app/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {

  var _appTheme = PrefUtils().getThemeData();
  //A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
    
  };
  //A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  // Changes the app theme
  void changeTheme(String theme) {
    _appTheme = theme;
  }

/// Returns the lightCode colors for the current theme
  LightCodeColors getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors(); 
  }
/// Returns the current theme data
  ThemeData getThemeData() {
    var colorScheme = _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimary,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: colorScheme.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          visualDensity:  const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.indigo300.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray500,
      )
    );
  }

  LightCodeColors themeColor() => getThemeColors();

  ThemeData themeData() => getThemeData();
}

class TextThemes {
  static textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: appTheme.whiteA700.withOpacity(0.87),
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: appTheme.whiteA700.withOpacity(0.87),
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      color: appTheme.whiteA700.withOpacity(0.87),
      fontSize: 32,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w700,
    ),

  );
}
//Class containing the supported color schemes
class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF8874FF),
    primaryContainer: Color(0XFFA30000),
    primaryFixed: Color.fromARGB(255, 245, 236, 255),
    secondaryContainer: Color(0XFFC9CC41),
    errorContainer: Color(0XFF525252),
    onPrimary: Color(0XFF121212),
    onPrimaryContainer: Color(0XFFC4C4C4),
    onError: Color(0XFF4181CC),
    onSecondaryContainer: Color(0XFF1C1C1C),
  );
}

class LightCodeColors {
  //Blue
  Color get blue900 => const Color.fromARGB(255, 197, 203, 235);
  Color get blue90001 => const Color.fromARGB(255, 97, 92, 139);
  //BlueGray
  Color get blueGray100 => const Color(0XFFCCCCCC);
  Color get blueGray600 => const Color(0XFF5D5D7B);
  Color get blueGray700 => const Color(0XFF525252);
  Color get blueGray70001 => const Color(0XFF565772);
  Color get blueGray900 => const Color(0XFF112256);
  Color get blueGray90001 => const Color(0XFF363636);
  //DeepOrange
  Color get deepOrange100 => const Color(0XFFFFC1C1);
  Color get deepOrange10001 => const Color(0XFFFFB3B6);
  Color get deepOrange50 => const Color(0XFFFEE2E3);
  Color get deepOrangeA100 => const Color(0XFFFE958E);
  //Gray
  Color get gray400 => const Color(0XFFBBBBBB);
  Color get gray40001 => const Color(0XFFAFAFAF);
  Color get gray500 => const Color(0XFF979797);
  Color get gray50001 => const Color(0XFF979797);
  Color get gray700 => const Color(0XFF7F4D4E);
  Color get gray900 => const Color(0XFF231F20);
  Color get gray90001 => const Color(0XFF262626);
  Color get gray90002 => const Color(0XFF1C1C1C);
  //Indigo
  Color get indigo200 => const Color(0XFF8EA8DD);
  Color get indigo20001 => const Color(0XFFA4B8EA);
  Color get indigo300 => const Color(0xff8687e70);
  Color get indigo30001 => const Color(0XFF8687E7);
  Color get indigo500 => const Color(0XFF425AC2);
  Color get indigoA100 => const Color(0XFF8E7CFF);
  Color get indigoA200 => const Color.fromARGB(255, 144, 104, 218);
  //Pink
  Color get pink200 => const Color(0XFFFFA6AD);
  //Red
  Color get red100 => const Color(0XFFFFCACE);
  Color get red200 => const Color(0XFFE98896);
  Color get red500 => const Color(0XFFEB4335);
  Color get redA200 => const Color(0XFFFC6262);
  //White
  Color get whiteA700 => const Color(0XFFFFFFFF);
  //Black
  Color get blackA700 => const Color.fromARGB(255, 25, 20, 29);
  //Teal
  Color get teal300 => const Color(0XFF41CCA7);
  Color get teal3001 => const Color(0XFF41A2CC);
  //Yellow
  Color get yellowA400 => const Color(0XFFE7EA15);
  Color get yellowA900 => const Color.fromARGB(255, 234, 216, 21);
}