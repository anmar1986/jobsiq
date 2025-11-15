import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences}) : super(const ThemeState()) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeToggled>(_onThemeToggled);
  }

  /// Load saved theme preference
  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeMode = _getSavedThemeMode();
    emit(state.copyWith(themeMode: savedThemeMode));
  }

  /// Change theme to specific mode
  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  /// Toggle between light and dark theme
  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _saveThemeMode(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  /// Get saved theme mode from SharedPreferences
  ThemeMode _getSavedThemeMode() {
    final savedMode = sharedPreferences.getString(_themePreferenceKey);

    switch (savedMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system; // Default to system if no preference saved
    }
  }

  /// Save theme mode to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    String modeString;

    switch (themeMode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }

    await sharedPreferences.setString(_themePreferenceKey, modeString);
  }
}
