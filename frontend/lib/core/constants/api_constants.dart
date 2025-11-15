import '../config/app_config.dart';

class ApiConstants {
  // Base URL - now dynamically configured based on environment and platform
  static String get baseUrl => AppConfig.baseUrl;
  static String get apiPrefix => AppConfig.apiPrefix;

  // Timeout durations
  static Duration get connectTimeout => AppConfig.connectTimeout;
  static Duration get receiveTimeout => AppConfig.receiveTimeout;

  // Auth Endpoints
  static String get login => '$apiPrefix/login';
  static String get register => '$apiPrefix/register';
  static String get logout => '$apiPrefix/logout';
  static String get logoutAll => '$apiPrefix/logout-all';
  static String get forgotPassword => '$apiPrefix/forgot-password';

  // User Endpoints
  static String get user => '$apiPrefix/user';
  static String get profile => '$apiPrefix/profile';
  static String get deleteProfile => '$apiPrefix/profile';
  static String get changePassword => '$apiPrefix/change-password';

  // Job Endpoints
  static String get jobs => '$apiPrefix/jobs';
  static String get featuredJobs => '$apiPrefix/jobs/featured';
  static String get myJobs => '$apiPrefix/my-jobs';

  // Saved Jobs Endpoints
  static String get savedJobs => '$apiPrefix/saved-jobs';

  // Applications Endpoints
  static String get myApplications => '$apiPrefix/my-applications';
  static String get applications => '$apiPrefix/applications';

  // CV Endpoints
  static String get myCvs => '$apiPrefix/my-cvs';

  // Company Endpoints
  static String get companies => '$apiPrefix/companies';
  static String get myCompanies => '$apiPrefix/my-companies';

  // Home Endpoints
  static String get home => '$apiPrefix/home';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}
