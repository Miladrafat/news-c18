import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        color: ColorsManager.lightPrimaryColor,
        fontWeight: FontWeight.w500
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: ColorsManager.lightPrimaryColor,
      secondary: ColorsManager.lightSecondaryColor,
      onSecondary: ColorsManager.greyColor,
      onPrimaryContainer: Colors.white
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white,
      thickness: 1.h,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: ColorsManager.lightPrimaryColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700
      ),
      labelMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        color: ColorsManager.greyColor,
        fontWeight: FontWeight.w500
      )
    )
  );
}