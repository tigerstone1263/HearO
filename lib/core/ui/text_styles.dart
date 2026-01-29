import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

AutoSizeText autoSizeText(String text, {double? fontSize, FontWeight? fontWeight, TextOverflow? overflow, double? minFontSize, TextAlign? textAlign,
  Color? color, AutoSizeGroup? group, int? maxLines, TextDecoration? decoration, Color? decorationColor, TextDecorationStyle? decorationStyle}){
  return AutoSizeText(text, minFontSize: minFontSize ?? 1, maxLines: maxLines ?? 1, group: group, textAlign: textAlign,
    style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color, overflow: overflow,
        decoration: decoration, decorationColor: decorationColor, decorationStyle: decorationStyle),);
}

abstract class TextStyles {
  static const TextStyle titleTextBold = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle headerTextBold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle largeTextBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle mediumTextBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle normalTextBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle smallTextBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle smallerTextBold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle titleTextRegular = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle headerTextRegular = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle largeTextRegular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle mediumTextRegular = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle normalTextRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle smallTextRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle smallerTextRegular = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
}