

import 'package:e_commerce_mobile_app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/check_box_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/chip_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/text_field_theme.dart';
import 'package:e_commerce_mobile_app/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonThemeData,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData dartTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.dartTextTheme,
    chipTheme: TChipTheme.dartChipTheme,
    appBarTheme: TAppBarTheme.dartAppBarTheme,
    checkboxTheme: TCheckBoxTheme.dartCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.dartBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.dartElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.dartOutlinedButtonThemeData,
    inputDecorationTheme: TTextFieldTheme.dartInputDecorationTheme
  );
}