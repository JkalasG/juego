import 'package:flutter/material.dart';

class AppTheme {
  // Paleta extraída del Logo Oficial (10_mascota_shiba_mf_coin.jpg)
  static const Color forestGreen = Color(0xFF0C5844);     // Verde Bosque Esmeralda
  static const Color forestGreenDark = Color(0xFF084031); // Verde Bosque Profundo
  static const Color mintGreen = Color(0xFF2ED59A);       // Verde Menta / Brotes
  static const Color sageGreen = Color(0xFFE2EFE9);       // Verde Salvia Claro
  static const Color shibaGold = Color(0xFFF6A843);        // Dorado / Pelo Shiba / Monedas MF
  static const Color shibaGoldDark = Color(0xFFD97706);    // Miel / Tostado
  static const Color waterBlue = Color(0xFF38BDF8);        // Azul Rocío / Agua
  static const Color coralSoft = Color(0xFFE15241);        // Coral para alerta de gastos

  // Fondos y Superficies Cálidas del Logo 10 (Marfil / Ivory)
  static const Color background = Color(0xFFFDFBF7);      // Marfil cálido oficial
  static const Color surfaceCard = Color(0xFFFFFFFF);     // Blanco puro para tarjetas
  static const Color surfaceMuted = Color(0xFFF4F8F5);    // Superficie suave verdosa
  static const Color border = Color(0xFFDDECE4);          // Borde orgánico sutil

  // Textos elegantes
  static const Color textPrimary = Color(0xFF13382D);     // Verde oscuro casi negro
  static const Color textSecondary = Color(0xFF4A6B60);   // Verde grisáceo medio
  static const Color textMuted = Color(0xFF86A398);       // Texto sutil

  static ThemeData get gardenTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: forestGreen,
      colorScheme: const ColorScheme.light(
        primary: forestGreen,
        secondary: mintGreen,
        tertiary: shibaGold,
        surface: surfaceCard,
        error: coralSoft,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF084031),
        onSurface: textPrimary,
      ),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border, width: 1.2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: forestGreen),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forestGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: forestGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceCard,
        elevation: 4,
        indicatorColor: mintGreen.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: forestGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: textSecondary, fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: forestGreen);
          }
          return const IconThemeData(color: textSecondary);
        }),
      ),
    );
  }
}
