import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.white,
        shadowColor: Color(0x1A000000),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // Context menu specific theming
      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
      ),
      hoverColor: Colors.grey.withOpacity(0.08),
      dividerColor: Colors.grey.withOpacity(0.2),
      iconTheme: const IconThemeData(
        color: Color(0xFF424242),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xFF212121),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF212121),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF757575),
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Color(0xFF1E1E1E),
        shadowColor: Color(0x40000000),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(const Color(0xFF2D2D2D)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: const Color(0xFF2D2D2D),
      ),
      hoverColor: Colors.white.withOpacity(0.08),
      dividerColor: Colors.grey.withOpacity(0.3),
      iconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 12,
        ),
      ),
    );
  }
}