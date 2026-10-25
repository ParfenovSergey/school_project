import 'package:flutter/material.dart';

/// Общая палитра иллюстрированного сайта: небо, бумага и тёплые акценты.
abstract final class StoryColors {
  static const ocean = Color(0xFF006C7D);
  static const deepOcean = Color(0xFF004C63);
  static const sky = Color(0xFF81DBDC);
  static const mint = Color(0xFFDDF3EC);
  static const paper = Color(0xFFFFFEF9);
  static const ink = Color(0xFF23424B);
  static const gold = Color(0xFFF5B63F);
  static const warmInk = Color(0xFF503015);
  static const leaf = Color(0xFF83A93D);
}

/// Локальные шрифты не требуют обращений к Google Fonts при открытии сайта.
ThemeData buildStoryTheme() {
  final colors = ColorScheme.fromSeed(seedColor: StoryColors.ocean).copyWith(
    primary: StoryColors.ocean,
    onPrimary: Colors.white,
    primaryContainer: StoryColors.mint,
    onPrimaryContainer: StoryColors.ink,
    secondary: const Color(0xFFA85C13),
    secondaryContainer: const Color(0xFFFFE3A3),
    surface: StoryColors.paper,
    onSurface: StoryColors.ink,
    onSurfaceVariant: const Color(0xFF4B6267),
    outlineVariant: const Color(0xFFD4E4DE),
    surfaceContainerLow: const Color(0xFFF1F8F0),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    fontFamily: 'Nunito',
  );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  const display = TextStyle(
    fontFamily: 'AmaticSC',
    fontWeight: FontWeight.w700,
    height: 1.12,
    color: StoryColors.ocean,
  );
  return base.copyWith(
    scaffoldBackgroundColor: StoryColors.paper,
    textTheme: base.textTheme.copyWith(
      headlineLarge: display.copyWith(fontSize: 64),
      headlineSmall: display.copyWith(fontSize: 44),
      titleLarge: display.copyWith(fontSize: 34),
      titleMedium: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 17,
        height: 1.4,
        fontWeight: FontWeight.w700,
        color: StoryColors.ink,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 16,
        height: 1.65,
        color: StoryColors.ink,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        height: 1.6,
        color: StoryColors.ink,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: StoryColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colors.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: StoryColors.warmInk,
        backgroundColor: StoryColors.gold,
        minimumSize: const Size(52, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        shape: shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: StoryColors.ocean,
        minimumSize: const Size(52, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        side: const BorderSide(color: StoryColors.ocean),
        shape: shape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: shape,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    dividerTheme: DividerThemeData(color: colors.outlineVariant),
    drawerTheme: const DrawerThemeData(backgroundColor: StoryColors.paper),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(
        StoryColors.ocean.withValues(alpha: 0.5),
      ),
    ),
  );
}
