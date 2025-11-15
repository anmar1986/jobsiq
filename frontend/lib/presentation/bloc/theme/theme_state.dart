import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({
    this.themeMode = ThemeMode.system,
  });

  /// Check if current theme is dark
  bool get isDarkMode {
    return themeMode == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    return themeMode == ThemeMode.light;
  }

  /// Check if current theme follows system
  bool get isSystemMode {
    return themeMode == ThemeMode.system;
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode];
}
