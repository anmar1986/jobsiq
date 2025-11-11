class AppConstants {
  // App Info
  static const String appName = 'JobsIQ';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userKey = 'user';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // User Types
  static const String jobSeeker = 'job_seeker';
  static const String companyOwner = 'company_owner';

  // Employment Types
  static const List<String> employmentTypes = [
    'full-time',
    'part-time',
    'contract',
    'freelance',
    'internship',
  ];

  // Experience Levels
  static const List<String> experienceLevels = [
    'entry',
    'junior',
    'mid',
    'senior',
    'lead',
  ];

  // Application Status
  static const List<String> applicationStatuses = [
    'pending',
    'reviewed',
    'shortlisted',
    'interview',
    'accepted',
    'rejected',
  ];

  // Pagination
  static const int defaultPageSize = 15;
  static const int maxPageSize = 50;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 255;
  static const int maxDescriptionLength = 5000;
}
