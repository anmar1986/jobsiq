class ApiConstants {
  // Base URL - Update this to match your environment
  // Android Emulator: Use 10.0.2.2 to access host machine's localhost
  // iOS Simulator: Use localhost or 127.0.0.1
  // Real Device: Use your computer's local network IP (e.g., 192.168.1.100)
  // Web: Use localhost or 127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const String apiPrefix = '/api';

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String login = '$apiPrefix/login';
  static const String register = '$apiPrefix/register';
  static const String logout = '$apiPrefix/logout';
  static const String logoutAll = '$apiPrefix/logout-all';

  // User Endpoints
  static const String user = '$apiPrefix/user';
  static const String profile = '$apiPrefix/profile';
  static const String deleteProfile = '$apiPrefix/profile';
  static const String changePassword = '$apiPrefix/change-password';

  // Job Endpoints
  static const String jobs = '$apiPrefix/jobs';
  static const String featuredJobs = '$apiPrefix/jobs/featured';
  static const String myJobs = '$apiPrefix/my-jobs';

  // Saved Jobs Endpoints
  static const String savedJobs = '$apiPrefix/saved-jobs';

  // Applications Endpoints
  static const String myApplications = '$apiPrefix/my-applications';
  static const String applications = '$apiPrefix/applications';

  // CV Endpoints
  static const String myCvs = '$apiPrefix/my-cvs';

  // Company Endpoints
  static const String companies = '$apiPrefix/companies';
  static const String myCompanies = '$apiPrefix/my-companies';

  // Home Endpoints
  static const String home = '$apiPrefix/home';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}
