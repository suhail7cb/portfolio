import 'package:flutter/material.dart';

/// Centralized color definitions for the application.
/// Supports modern obsidian dark mode and crisp light mode.
class AppColors {
  AppColors._();

  // Primary brand accents
  static const Color primary = Color(0xFF00E5FF); // Neon Cyan
  static const Color primaryDark = Color(0xFF00B4D8);
  static const Color secondary = Color(0xFF6366F1); // Electric Indigo
  static const Color accent = Color(0xFF8B5CF6); // Violet

  // Status & Highlights
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF38BDF8); // Sky Blue
  static const Color error = Color(0xFFEF4444); // Red

  // Dark Theme Palette (Modern Obsidian)
  static const Color darkBackground = Color(0xFF0A0D14);
  static const Color darkSurface = Color(0xFF111625);
  static const Color darkCard = Color(0xFF161D31);
  static const Color darkBorder = Color(0xFF222C46);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Light Theme Palette (Crisp Modern Slate)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF818CF8), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowDark = LinearGradient(
    colors: [Color(0x1A00E5FF), Color(0x1A6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
