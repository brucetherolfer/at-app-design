import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Teal accent (primary)
  static const tealPrimary = Color(0xFF48CAE4);
  static const tealDeep    = Color(0xFF0096C7);
  static const tealLight   = Color(0xFF90E0EF);
  static const tealPale    = Color(0xFFCAF0F8);

  // Transparent teal variants (for borders, text, buttons)
  static Color tealP(double opacity) => tealPrimary.withOpacity(opacity);
  static Color tealD(double opacity) => tealDeep.withOpacity(opacity);

  // Text colors — Night mode (default)
  static const Color textPrompt       = Color(0xF2FFFFFF); // rgba(255,255,255,0.95)
  static const Color textAppNameNight = Color(0x66F0F0F0); // rgba(240,240,240,0.40)
  static const Color textAppNameDay   = Color(0xBFF0F0F0); // rgba(240,240,240,0.75)

  // Status text
  static Color statusDay   = tealPrimary.withOpacity(0.80);
  static Color statusNight = tealPrimary.withOpacity(0.45);

  // Countdown label
  static Color countdownLabelDay   = const Color(0xFF8CF0F0F0); // rgba(240,240,240,0.55)
  static Color countdownLabelNight = const Color(0x33F0F0F0);   // rgba(240,240,240,0.20)
  static Color countdownValueDay   = tealPrimary.withOpacity(0.85);
  static Color countdownValueNight = tealPrimary.withOpacity(0.50);

  // Row text (inner screens)
  static const Color rowText    = Color(0xE0F0F0F0); // rgba(240,240,240,0.88)
  static const Color rowSubtext = Color(0x47F0F0F0); // rgba(240,240,240,0.28)

  // Section labels
  static Color sectionLabel = tealPrimary.withOpacity(0.35);

  // Surfaces (inner screens)
  static const Color cardBackground = Color(0x08FFFFFF); // rgba(255,255,255,0.03)
  static const Color cardBorder     = Color(0x12FFFFFF); // rgba(255,255,255,0.07)
  static const Color rowDivider     = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)

  // Buttons
  static Color pillBorder        = tealPrimary.withOpacity(0.45);
  static Color pillBorderHover   = tealPrimary.withOpacity(0.85);
  static Color pillBgHover       = tealPrimary.withOpacity(0.07);
  static Color pillBgRunning     = tealPrimary.withOpacity(0.08);
  static const Color pillText    = Color(0xCCF0F0F0); // rgba(240,240,240,0.80)

  // Icon/secondary buttons
  static Color iconButtonBorder  = const Color(0xFFFFFFFF).withOpacity(0.25);
  static Color iconButtonLabel   = const Color(0xFFFFFFFF).withOpacity(0.75);

  // Ripple rings
  static Color rippleBorder = tealPrimary.withOpacity(0.2);

  // Tags
  static Color tagTeal          = tealPrimary.withOpacity(0.45);
  static Color tagTealBorder    = tealPrimary.withOpacity(0.20);
  static Color tagActiveTeal    = tealPrimary.withOpacity(0.70);
  static Color tagActiveBorder  = tealPrimary.withOpacity(0.30);
  static Color tagActiveBg      = tealPrimary.withOpacity(0.07);

  // Toggle
  static Color toggleTrackOff   = tealPrimary.withOpacity(0.15);
  static Color toggleBorderOff  = tealPrimary.withOpacity(0.20);
  static Color toggleTrackOn    = tealPrimary.withOpacity(0.35);
  static Color toggleBorderOn   = tealPrimary.withOpacity(0.50);
  static Color toggleThumbOff   = const Color(0xFFFFFFFF).withOpacity(0.35);
  static const Color toggleThumbOn    = Color(0xF248CAE4); // rgba(72,202,228,0.95)

  // Settings sheet
  static const Color sheetBackground = Color(0xF70A1420); // rgba(10,20,32,0.97)
  static const Color sheetDragHandle = Color(0x26FFFFFF); // rgba(255,255,255,0.15)
  static const Color sheetRowLabel   = Color(0xC7F0F0F0); // rgba(240,240,240,0.78)
  static const Color sheetRowSub     = Color(0x40F0F0F0); // rgba(240,240,240,0.25)
  static const Color sheetBackdrop   = Color(0x8C000000); // rgba(0,0,0,0.55)

  // Dashed add button
  static Color dashedBorder = tealPrimary.withOpacity(0.25);
  static Color dashedBg     = tealPrimary.withOpacity(0.04);
  static Color dashedText   = tealPrimary.withOpacity(0.55);

  // Drag handle
  static Color dragHandle = const Color(0xFFFFFFFF).withOpacity(0.18);

  // Nav back button
  static Color navBack = tealPrimary.withOpacity(0.85);
}
