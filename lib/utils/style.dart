import 'package:flutter/material.dart';

//颜色配置
class AppColor {
  static Color colorGreen = const Color(gridGreen);
  static const int gridGreen = 0xFF00706b; //电网绿
  static const int white = 0xFFFFFFFF;
  static const int mainTextColor = 0xFF121917;
  static const int subTextColor = 0xff959595;
  static const MaterialColor elGreen = MaterialColor(
    0xFF00706b,
    <int, Color>{
      50: Color(0xFFE1F3F4),
      100: Color(0xFFB4E1E2),
      200: Color(0xFF82CFD0),
      300: Color(0xFF4EBCBB),
      400: Color(0xFF25ADAB),
      500: Color(0xFF009E9A),
      600: Color(0xFF00908C),
      700: Color(0xFF00807B),
      800: Color(0xFF00706A),
      900: Color(0xFF02544D),
    },
  );
}
