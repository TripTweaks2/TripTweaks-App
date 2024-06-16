import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {

  ///App Basic Colors
  static const Color primaryElement = Color.fromARGB(255, 194, 91, 60);
  static const Color secondaryElement = Color.fromARGB(255, 190, 115, 90);

  ///Text Colors
  static const Color primaryText = Color.fromARGB(255, 0, 0, 0);
  static const Color secondaryText = Color.fromARGB(255, 102, 102, 102);
  static const Color textWhite = Colors.white;

  ///Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ],
  );


  ///Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color.fromARGB(255, 255, 255, 255);

  ///Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = AppColors.white.withOpacity(0.1);


  /// Button Colors
  static const Color buttonPrimary = Color.fromARGB(255, 190, 115, 90);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);



  /// Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);


  /// Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color info = Color(0xFFF57C00);
  static const Color warning = Color(0xFF1976D2);

  // main widget text color grey

  // main widget third color grey
  /// Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

}