import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle promptText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.34, // 0.02em × 17
    height: 1.55,
    color: AppColors.textPrompt,
  );

  static const TextStyle appNameDay = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.32, // 0.12em × 11
    color: AppColors.textAppNameDay,
  );

  static const TextStyle appNameNight = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.32,
    color: AppColors.textAppNameNight,
  );

  static TextStyle statusDay = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.4, // 0.14em × 10
    color: AppColors.statusDay,
  );

  static TextStyle statusNight = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.4,
    color: AppColors.statusNight,
  );

  static TextStyle countdownLabelDay = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.44, // 0.16em × 9
    color: AppColors.countdownLabelDay,
  );

  static TextStyle countdownLabelNight = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.44,
    color: AppColors.countdownLabelNight,
  );

  static TextStyle countdownValueDay = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w200,
    letterSpacing: 1.04, // 0.04em × 26
    color: AppColors.countdownValueDay,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle countdownValueNight = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w200,
    letterSpacing: 1.04,
    color: AppColors.countdownValueNight,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static const TextStyle navTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.44, // 0.12em × 12
    color: Color(0xEBFFFFFF), // rgba(255,255,255,0.92)
  );

  static const TextStyle navBack = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.28, // 0.02em × 14
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.8, // 0.20em × 9
  );

  static const TextStyle rowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.14, // 0.01em × 14
    color: AppColors.rowText,
  );

  static const TextStyle rowSublabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.22, // 0.02em × 11
    color: AppColors.rowSubtext,
  );

  static const TextStyle pillLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.44, // 0.12em × 12
    color: AppColors.pillText,
  );

  static const TextStyle tagLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.72, // 0.08em × 9
  );

  static const TextStyle fireButtonLabel = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.96, // 0.12em × 8
  );

  static const TextStyle sheetTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.44,
    color: Color(0xEBFFFFFF),
  );

  static const TextStyle sheetRowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.sheetRowLabel,
  );

  static const TextStyle sheetRowSub = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: AppColors.sheetRowSub,
  );
}
