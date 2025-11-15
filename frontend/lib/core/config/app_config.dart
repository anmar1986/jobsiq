import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Application configuration for different environments
///
/// Usage:
/// - Development: Use default values (automatically detects platform)
/// - Production: Pass --dart-define=API_BASE_URL=https://api.jobsiq.com when building
///
/// Example build commands:
/// - Android Debug: flutter run
/// - iOS Debug: flutter run
/// - Production Android: flutter build apk --dart-define=API_BASE_URL=https://api.jobsiq.com --dart-define=ENV=production
/// - Production iOS: flutter build ios --dart-define=API_BASE_URL=https://api.jobsiq.com --dart-define=ENV=production
class AppConfig {
  /// Current environment (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// API Base URL - configurable via --dart-define
  static String get baseUrl {
    // Check for build-time environment variable first
    const String envBaseUrl = String.fromEnvironment('API_BASE_URL');

    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    // Default URLs based on platform (for development)
    if (kIsWeb) {
      // Web: use localhost
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // Android Emulator: use 10.0.2.2 to access host machine
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS Simulator: use localhost
      return 'http://localhost:8000';
    } else {
      // Default fallback
      return 'http://localhost:8000';
    }
  }

  /// Storage base URL for images/files
  static String get storageBaseUrl => '$baseUrl/storage';

  /// API prefix
  static const String apiPrefix = '/api';

  /// Full API URL
  static String get apiUrl => '$baseUrl$apiPrefix';

  /// Whether app is in debug mode
  static bool get isDebug => environment == 'development';

  /// Whether app is in production
  static bool get isProduction => environment == 'production';

  /// Whether app is in staging
  static bool get isStaging => environment == 'staging';

  /// Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Helper to build storage URL for a given path
  static String getStorageUrl(String path) {
    if (path.isEmpty) return '';

    // If path is already a full URL, return it
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Remove leading slash if present
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;

    return '$storageBaseUrl/$cleanPath';
  }

  /// Prints the current configuration (for debugging)
  static void printConfig() {
    debugPrint('=== App Configuration ===');
    debugPrint('Environment: $environment');
    debugPrint('Base URL: $baseUrl');
    debugPrint('API URL: $apiUrl');
    debugPrint('Storage URL: $storageBaseUrl');
    debugPrint('Is Debug: $isDebug');
    debugPrint('Is Production: $isProduction');
    debugPrint('========================');
  }
}
