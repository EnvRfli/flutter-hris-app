import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Soft Modern Theme
  // Menggunakan warna yang lebih soft dan pastel untuk mengurangi kontras

  // Purple/Indigo - Primary
  static const Color primary = Color(0xFF6366F1); // Soft Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFEEF2FF);

  // Teal - Secondary
  static const Color secondary = Color(0xFF14B8A6); // Soft Teal
  static const Color secondaryLight = Color(0xFF5EEAD4);
  static const Color secondaryDark = Color(0xFF0F766E);
  static const Color secondaryContainer = Color(0xFFCCFBF1);

  // Accent Colors (Soft)
  static const Color accent1 = Color(0xFFEC4899); // Soft Pink
  static const Color accent2 = Color(0xFFF59E0B); // Soft Amber
  static const Color accent3 = Color(0xFF8B5CF6); // Soft Purple

  // Status Colors (Soft versions)
  static const Color success = Color(0xFF10B981); // Soft Green
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color successDark = Color(0xFF059669);
  static const Color successContainer = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFF59E0B); // Soft Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444); // Soft Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6); // Soft Blue
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // Neutral Colors (Softer)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111827); // Softer black
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFE5E7EB);
  static const Color greyDark = Color(0xFF4B5563);
  static const Color greyExtraLight = Color(0xFFF9FAFB);

  // Background Colors (Softer)
  static const Color background = Color(0xFFF9FAFB); // Very soft grey
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color surfaceContainer = Color(0xFFEFF6FF);

  // Text Colors (Less harsh)
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
