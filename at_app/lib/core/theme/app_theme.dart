import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.tealPrimary,
          secondary: AppColors.tealDeep,
          surface: Color(0xFF0D2137),
        ),
        // Remove default app bar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.tealPrimary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        // No card elevation
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        // Text
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.rowText,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          bodySmall: TextStyle(
            color: AppColors.rowSubtext,
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
        ),
        // Page transitions
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.rowDivider,
          thickness: 1,
          space: 0,
        ),
      );
}
