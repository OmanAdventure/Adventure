import 'package:flutter/material.dart';
Color themeColor = const Color(0xFF700464);
class Styles{
  static Color primaryColor = themeColor;
  static Color textColor = const Color(0xff000000);
  // Background Color
  static Color bgLightModeColor = const Color(0xFFeeedf2);
  static Color bgDarkModeColor = const Color(0xFF000000);

  static Color textLightModeColor = const Color(0xFF000000);
  static Color textDarkModeColor = const Color(0xFFeeedf2);

  static TextStyle textStyle = TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle2 = TextStyle(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle3 = TextStyle(fontSize: 17, color: textColor, fontWeight:FontWeight.bold);
  static TextStyle headLineStyle4 = TextStyle(fontSize: 14, color: Colors.grey.shade500,  fontWeight:FontWeight.w500);

  static Color buttonsColor =  Colors.red;

  static Color iconsColor = themeColor;
  static Color appBarColor = themeColor;

}

/// Styles.bgColor