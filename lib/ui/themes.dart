// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Meditation theme colors derived from the enpleineconscience.ch logo:
/// - Figure body: warm taupe/mauve-brown
/// - Cushion: deep burgundy/maroon
const _meditationBrown = Color(0xFF7B5B5B);
const _meditationBrownLight = Color(0xFFC4A8A8);
const _meditationBurgundy = Color(0xFF5C1010);
const _meditationBurgundyDark = Color(0xFF3D0808);
const _warmWhite = Color(0xFFFFF8F5);

final ThemeData _lightTheme = _buildLightTheme();
final ThemeData _darkTheme = _buildDarkTheme();

ThemeData _buildLightTheme() {
  final base = ThemeData.light(useMaterial3: false);

  return base.copyWith(
    colorScheme: const ColorScheme.light(
      primary: _meditationBrown,
      secondary: _meditationBurgundy,
      surface: Color(0xffffffff),
      error: Color(0xffd32f2f),
      onSurface: _meditationBurgundy,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData().copyWith(
      color: _warmWhite,
    ),
    cardTheme: const CardThemeData().copyWith(
      color: _meditationBrown,
      shadowColor: _meditationBurgundyDark,
    ),
    brightness: Brightness.light,
    primaryColor: _meditationBrown,
    primaryColorLight: _meditationBrownLight,
    primaryColorDark: _meditationBurgundy,
    canvasColor: _warmWhite,
    scaffoldBackgroundColor: _warmWhite,
    cardColor: const Color(0xffffffff),
    dividerColor: const Color(0x1f000000),
    highlightColor: const Color(0x66bcbcbc),
    splashColor: const Color(0x66c8c8c8),
    unselectedWidgetColor: const Color(0x8a000000),
    disabledColor: const Color(0x61000000),
    secondaryHeaderColor: _warmWhite,
    dialogBackgroundColor: const Color(0xffffffff),
    indicatorColor: _meditationBurgundy,
    hintColor: const Color(0x8a000000),
    primaryTextTheme: Typography.material2021(platform: TargetPlatform.android).black,
    textTheme: Typography.material2021(
      platform: TargetPlatform.android,
    ).black,
    primaryIconTheme: IconThemeData(color: Colors.grey[800]),
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: _meditationBrown,
    ),
    iconTheme: base.iconTheme.copyWith(
      color: _meditationBrown,
    ),
    sliderTheme: const SliderThemeData().copyWith(
      valueIndicatorColor: _meditationBrown,
      trackHeight: 2.0,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6.0,
        disabledThumbRadius: 6.0,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: _warmWhite,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: _warmWhite,
          statusBarIconBrightness: Brightness.dark,
        )),
    snackBarTheme: base.snackBarTheme.copyWith(
      actionTextColor: Colors.white,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[800]),
    ),
  );
}

ThemeData _buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: false);

  return base.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xffffffff),
      secondary: _meditationBrownLight,
      surface: Color(0xff222222),
      error: Color(0xffd32f2f),
      onSurface: Color(0xffffffff),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData().copyWith(
      color: const Color(0xff222222),
    ),
    cardTheme: const CardThemeData().copyWith(
      color: const Color(0xff444444),
      shadowColor: const Color(0x77ffffff),
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xffffffff),
    primaryColorLight: _meditationBrownLight,
    primaryColorDark: _meditationBurgundy,
    canvasColor: const Color(0xff000000),
    scaffoldBackgroundColor: const Color(0xff000000),
    cardColor: const Color(0xff0F0F0F),
    dividerColor: const Color(0xff444444),
    highlightColor: const Color(0xff222222),
    splashColor: const Color(0x66c8c8c8),
    unselectedWidgetColor: Colors.white,
    disabledColor: const Color(0x77ffffff),
    secondaryHeaderColor: const Color(0xff222222),
    dialogBackgroundColor: const Color(0xff222222),
    indicatorColor: _meditationBrownLight,
    hintColor: const Color(0x80ffffff),
    primaryTextTheme: Typography.material2021(platform: TargetPlatform.android).white,
    textTheme: Typography.material2021(platform: TargetPlatform.android).white,
    primaryIconTheme: const IconThemeData(color: Colors.white),
    iconTheme: base.iconTheme.copyWith(
      color: Colors.white,
    ),
    dividerTheme: base.dividerTheme.copyWith(
      color: const Color(0xff444444),
    ),
    sliderTheme: const SliderThemeData().copyWith(
      valueIndicatorColor: Colors.white,
      trackHeight: 2.0,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6.0,
        disabledThumbRadius: 6.0,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xff222222),
        foregroundColor: Colors.white,
        shadowColor: const Color(0xff222222),
        elevation: 1.0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: const Color(0xff222222),
          statusBarIconBrightness: Brightness.light,
        )),
    snackBarTheme: base.snackBarTheme.copyWith(
      actionTextColor: _meditationBrownLight,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xffffffff),
        side: const BorderSide(
          color: Color(0xffffffff),
          style: BorderStyle.solid,
        ),
      ),
    ),
  );
}

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
