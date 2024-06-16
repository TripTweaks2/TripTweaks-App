import 'package:flutter/material.dart';
import 'package:tesis3/utils/theme/custom_Theme/text_themes.dart';

import 'custom_Theme/app_bars_theme.dart';
import 'custom_Theme/bottom_sheet_theme.dart';
import 'custom_Theme/checkbox_theme.dart';
import 'custom_Theme/chip_theme.dart';
import 'custom_Theme/elevated_buttons.dart';
import 'custom_Theme/outline_buttons.dart';
import 'custom_Theme/text_field_theme.dart';

class TAppTheme{
  TAppTheme._();
  static ThemeData lightTheme=ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.orangeAccent,
    textTheme: Text_Theme.lightTextTheme,
    chipTheme: ChipThemes.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarsTheme.lightAppBarTheme,
    checkboxTheme: CheckBoxTheme.lightCheckbox,
    bottomSheetTheme: BottomSheetTheme.lightBottomSheet,
    elevatedButtonTheme:ElevatedButtons.lightElevatedButtonTheme,
    outlinedButtonTheme: OutlineButtons.lightOutlineButtonTheme,
    inputDecorationTheme: TextFieldThemes.lightInputDecoration
  );


  static ThemeData darkTheme=ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.orangeAccent,
      textTheme: Text_Theme.darkTextTheme,
      chipTheme: ChipThemes.darkChipTheme,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarsTheme.darkAppBarTheme,
      checkboxTheme: CheckBoxTheme.darkCheckbox,
      bottomSheetTheme: BottomSheetTheme.darkBottomSheet,
      elevatedButtonTheme:ElevatedButtons.darkElevatedButtonTheme,
      outlinedButtonTheme: OutlineButtons.darkOutlineButtonTheme,
      inputDecorationTheme: TextFieldThemes.darkInputDecoration
  );

}