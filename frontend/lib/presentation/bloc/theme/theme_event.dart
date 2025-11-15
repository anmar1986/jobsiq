import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change theme mode
class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// Event to toggle between light and dark theme
class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

/// Event to load saved theme preference
class ThemeLoaded extends ThemeEvent {
  const ThemeLoaded();
}
