part of '../main.dart';

ThemeData _crearTemaReakt() => ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: const Color(0xFFE3262E),
  scaffoldBackgroundColor: ReaktColors.background,
  appBarTheme: const AppBarTheme(backgroundColor: ReaktColors.background),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: ReaktColors.accent,
      foregroundColor: Colors.white,
      minimumSize: const Size(48, 52),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  useMaterial3: true,
);
