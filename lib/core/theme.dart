import 'package:flutter/material.dart';

const purple = Color(0xFF8581FF),
    teal = Color(0xFF75BFCF),
    pink = Color(0xFFFFAEC3);
const ink = Color(0xFF031637),
    muted = Color(0xFF8A8E9C),
    lavender = Color(0xFFEDEBFF);
const cream = Color(0xFFFFF7EB), blush = Color(0xFFFFF0FA);

ThemeData appTheme(bool dark) {
  final fg = dark ? Colors.white : ink;
  final bg = dark ? const Color(0xFF07152C) : Colors.white;
  final border = dark ? const Color(0xFF142B50) : const Color(0xFFF0F6F8);
  final base = ThemeData(
    fontFamily: 'Inter',
    brightness: dark ? Brightness.dark : Brightness.light,
    useMaterial3: true,
  );
  return base.copyWith(
    scaffoldBackgroundColor: bg,
    canvasColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: purple,
      brightness: dark ? Brightness.dark : Brightness.light,
    ).copyWith(primary: purple, surface: bg, onSurface: fg, outline: border),
    textTheme: base.textTheme
        .apply(bodyColor: fg, displayColor: fg)
        .copyWith(
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            height: 1.45,
            color: fg,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: fg,
            letterSpacing: -.6,
          ),
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: 88,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
    ),
    dividerColor: border,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: purple),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bg,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
  );
}

extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get foreground => Theme.of(this).colorScheme.onSurface;
  Color get line => Theme.of(this).colorScheme.outline;
  Color tint(Color light) => isDark ? const Color(0xFF0C2040) : light;
}
