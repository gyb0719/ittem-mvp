import 'package:flutter/material.dart';

class AppColors {
  // Primary colors inspired by GPT icon teal/turquoise - 4-tier teal system
  static const Color primary = Color(0xFF5CBDBD); // Main teal from the icon
  static const Color primaryVariant = Color(0xFF4A9E9E); // Dark teal for emphasis
  static const Color secondary = Color(0xFF72D5D5); // Light teal for secondary elements
  static const Color accent = Color(0xFF45A5A5); // Darker teal accent
  static const Color tealPale = Color(0xFFE5F7F7); // Pale teal for backgrounds/cards
  
  // Light theme colors (c2.png 스타일에 맞춘 밝고 깔끔한 색상)
  static const Color background = Color(0xFFF9FAFB); // 매우 밝은 회색
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color navigationBar = Color(0xFFFFFFFF);
  
  // Text colors - light theme
  static const Color textPrimary = Color(0xFF1E293B); // Dark slate
  static const Color textSecondary = Color(0xFF64748B); // Medium slate
  static const Color textTertiary = Color(0xFF94A3B8); // Light slate
  
  // Dark theme colors
  static const Color backgroundDark = Color(0xFF0F172A); // Very dark slate
  static const Color surfaceDark = Color(0xFF1E293B); // Dark slate
  static const Color cardBackgroundDark = Color(0xFF1E293B);
  static const Color navigationBarDark = Color(0xFF0F172A);
  
  // Text colors - dark theme
  static const Color textPrimaryDark = Color(0xFFF1F5F9); // Very light slate
  static const Color textSecondaryDark = Color(0xFFCBD5E1); // Light slate
  static const Color textTertiaryDark = Color(0xFF94A3B8); // Medium slate
  
  // System colors
  static const Color error = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Neutral colors
  static const Color separator = Color(0xFFE2E8F0);
  static const Color separatorDark = Color(0xFF334155);
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  static const Color overlay = Color(0x80000000);
  
  // Map specific colors
  static const Color mapClusterSmall = Color(0xFF72D5D5);
  static const Color mapClusterMedium = Color(0xFF5CBDBD);
  static const Color mapClusterLarge = Color(0xFF4A9E9E);
  static const Color mapUserLocation = Color(0xFF45A5A5);
  
  // Status colors
  static const Color available = Color(0xFF10B981);
  static const Color rented = Color(0xFFF59E0B);
  static const Color archived = Color(0xFF64748B);
  
  // Rental status colors
  static const Color requested = Color(0xFF5CBDBD);
  static const Color accepted = Color(0xFF10B981);
  static const Color rejected = Color(0xFFEF4444);
  static const Color paid = Color(0xFF45A5A5);
  static const Color completed = Color(0xFF059669);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5CBDBD), Color(0xFF72D5D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF45A5A5), Color(0xFF5CBDBD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}