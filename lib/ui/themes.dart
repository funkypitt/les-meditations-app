// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The palette comes from the enpleineconscience.ch logo and nothing else: the
/// warm off-white ground, the mauve-brown of the figure and the burgundy of the
/// cushion. Burgundy is the only strong colour and is reserved for what plays:
/// the play button, the progress track, the selected tab. Everything else is a
/// tint of the mauve, and nothing carries a shadow.
class Palette {
  final Color ground; // scaffold, app bar, sheets
  final Color tint; // soft surfaces: rows, chips, quiet buttons
  final Color tintStrong; // pressed / selected surfaces, nav indicator
  final Color ink; // primary text
  final Color inkSoft; // secondary text, icons
  final Color line; // hairline dividers
  final Color accent; // burgundy: play, progress
  final Color onAccent;
  final Brightness brightness;

  const Palette({
    required this.ground,
    required this.tint,
    required this.tintStrong,
    required this.ink,
    required this.inkSoft,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.brightness,
  });

  static const light = Palette(
    ground: Color(0xFFFBF5F2),
    tint: Color(0xFFF1E6E2),
    tintStrong: Color(0xFFE6D5CF),
    ink: Color(0xFF2B1D1D),
    inkSoft: Color(0xFF7B5B5B),
    line: Color(0xFFEADCD7),
    accent: Color(0xFF5C1010),
    onAccent: Color(0xFFFBF5F2),
    brightness: Brightness.light,
  );

  static const dark = Palette(
    ground: Color(0xFF1B1515),
    tint: Color(0xFF2A2222),
    tintStrong: Color(0xFF3A2F2F),
    ink: Color(0xFFF3E9E6),
    inkSoft: Color(0xFFC4A8A8),
    line: Color(0xFF322828),
    accent: Color(0xFFB5504E),
    onAccent: Color(0xFF1B1515),
    brightness: Brightness.dark,
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

const String _fontFamily = 'Montserrat';

TextTheme _textTheme(Palette p) {
  TextStyle s(double size, double height, FontWeight weight, {Color? color, double spacing = 0}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
        color: color ?? p.ink,
        letterSpacing: spacing,
      );

  return TextTheme(
    displayLarge: s(40, 48, FontWeight.w700, spacing: -0.5),
    displayMedium: s(34, 42, FontWeight.w700, spacing: -0.5),
    displaySmall: s(30, 38, FontWeight.w700, spacing: -0.25),
    headlineLarge: s(28, 36, FontWeight.w700, spacing: -0.25),
    headlineMedium: s(24, 32, FontWeight.w700, spacing: -0.25),
    headlineSmall: s(22, 30, FontWeight.w700),
    titleLarge: s(22, 30, FontWeight.w500),
    titleMedium: s(18, 26, FontWeight.w500),
    titleSmall: s(16, 22, FontWeight.w500),
    bodyLarge: s(17, 25, FontWeight.w400),
    bodyMedium: s(16, 24, FontWeight.w400),
    bodySmall: s(14, 20, FontWeight.w400, color: p.inkSoft),
    labelLarge: s(16, 22, FontWeight.w500),
    labelMedium: s(14, 20, FontWeight.w500),
    labelSmall: s(13, 18, FontWeight.w500, color: p.inkSoft),
  );
}

ThemeData _buildTheme(Palette p) {
  final isDark = p.brightness == Brightness.dark;
  final textTheme = _textTheme(p);

  final colorScheme = ColorScheme(
    brightness: p.brightness,
    primary: p.accent,
    onPrimary: p.onAccent,
    primaryContainer: p.tintStrong,
    onPrimaryContainer: p.ink,
    secondary: p.inkSoft,
    onSecondary: p.ground,
    secondaryContainer: p.tintStrong,
    onSecondaryContainer: p.ink,
    tertiary: p.inkSoft,
    onTertiary: p.ground,
    tertiaryContainer: p.tint,
    onTertiaryContainer: p.ink,
    error: isDark ? const Color(0xFFE0827E) : const Color(0xFFB3261E),
    onError: p.ground,
    errorContainer: isDark ? const Color(0xFF5A2321) : const Color(0xFFF9DEDC),
    onErrorContainer: p.ink,
    surface: p.ground,
    onSurface: p.ink,
    surfaceDim: p.tint,
    surfaceBright: p.ground,
    surfaceContainerLowest: p.ground,
    surfaceContainerLow: p.ground,
    surfaceContainer: p.tint,
    surfaceContainerHigh: p.tint,
    surfaceContainerHighest: p.tintStrong,
    onSurfaceVariant: p.inkSoft,
    outline: p.inkSoft,
    outlineVariant: p.line,
    shadow: Colors.transparent,
    scrim: Colors.black54,
    inverseSurface: p.ink,
    onInverseSurface: p.ground,
    inversePrimary: p.tintStrong,
    surfaceTint: Colors.transparent,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: p.brightness,
    colorScheme: colorScheme,
    fontFamily: _fontFamily,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
  );

  final overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: p.brightness,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  return base.copyWith(
    // Legacy properties still read across the widgets.
    primaryColor: p.accent,
    primaryColorLight: p.tintStrong,
    primaryColorDark: p.accent,
    canvasColor: p.ground,
    scaffoldBackgroundColor: p.ground,
    cardColor: p.tint,
    dividerColor: p.line,
    highlightColor: p.tintStrong,
    splashColor: p.tintStrong.withValues(alpha: 0.6),
    splashFactory: InkRipple.splashFactory,
    unselectedWidgetColor: p.inkSoft,
    disabledColor: p.inkSoft.withValues(alpha: 0.4),
    secondaryHeaderColor: p.ground,
    hintColor: p.inkSoft,
    iconTheme: IconThemeData(color: p.inkSoft, size: 24),
    primaryIconTheme: IconThemeData(color: p.inkSoft, size: 24),
    dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: p.ground,
      foregroundColor: p.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: p.inkSoft),
      titleTextStyle: textTheme.titleMedium,
      systemOverlayStyle: overlay,
    ),
    bottomAppBarTheme: BottomAppBarThemeData(color: p.ground, elevation: 0, surfaceTintColor: Colors.transparent),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.ground,
      surfaceTintColor: Colors.transparent,
      indicatorColor: p.tintStrong,
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelMedium!.copyWith(
          color: states.contains(WidgetState.selected) ? p.ink : p.inkSoft,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(color: states.contains(WidgetState.selected) ? p.ink : p.inkSoft),
      ),
    ),
    cardTheme: CardThemeData(
      color: p.tint,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: p.inkSoft,
      textColor: p.ink,
      titleTextStyle: textTheme.bodyLarge,
      subtitleTextStyle: textTheme.bodySmall,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.ground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.ground,
      modalBackgroundColor: p.ground,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      dragHandleColor: p.tintStrong,
      showDragHandle: false,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: p.ground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: textTheme.bodyMedium,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: p.ink,
      unselectedLabelColor: p.inkSoft,
      labelStyle: textTheme.titleSmall,
      unselectedLabelStyle: textTheme.titleSmall,
      indicatorColor: p.accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(p.tint),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 6,
      activeTrackColor: p.accent,
      inactiveTrackColor: p.tintStrong,
      secondaryActiveTrackColor: p.tintStrong,
      thumbColor: p.accent,
      overlayColor: p.accent.withValues(alpha: 0.12),
      valueIndicatorColor: p.ink,
      valueIndicatorTextStyle: textTheme.labelMedium!.copyWith(color: p.ground),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, disabledThumbRadius: 8, elevation: 0),
      trackShape: const RoundedRectSliderTrackShape(),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent, linearTrackColor: p.tintStrong),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.accent,
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.ink,
        side: BorderSide(color: p.tintStrong),
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.tint,
        foregroundColor: p.ink,
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: p.inkSoft, highlightColor: p.tintStrong),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.onAccent : p.inkSoft),
      trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.accent : p.tintStrong),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.accent : Colors.transparent),
      checkColor: WidgetStatePropertyAll(p.onAccent),
      side: BorderSide(color: p.inkSoft, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.accent : p.inkSoft),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.tint,
      selectedColor: p.tintStrong,
      labelStyle: textTheme.labelMedium,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.tint,
      hintStyle: textTheme.bodyMedium!.copyWith(color: p.inkSoft),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: p.accent)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.ink,
      contentTextStyle: textTheme.bodyMedium!.copyWith(color: p.ground),
      actionTextColor: p.tintStrong,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: p.ink, borderRadius: BorderRadius.circular(8)),
      textStyle: textTheme.labelMedium!.copyWith(color: p.ground),
    ),
  );
}

final ThemeData _lightTheme = _buildTheme(Palette.light);
final ThemeData _darkTheme = _buildTheme(Palette.dark);

class Themes {
  final ThemeData themeData;

  Themes({required this.themeData});

  factory Themes.lightTheme() {
    return Themes(themeData: _lightTheme);
  }

  factory Themes.darkTheme() {
    return Themes(themeData: _darkTheme);
  }
}
