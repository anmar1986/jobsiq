import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/entities/cv_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../presentation/pages/main/main_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/jobs/job_details_page.dart';
import '../../presentation/pages/cvs/cv_details_page.dart';
import '../../presentation/pages/cvs/create_cv_page.dart';
import '../../presentation/pages/cvs/edit_cv_page.dart';
import '../../presentation/pages/companies/companies_page.dart';
import '../../presentation/pages/companies/company_details_page.dart';
import '../../presentation/pages/profile/edit_profile_page.dart';
import '../../presentation/pages/profile/change_password_page.dart';
import '../../presentation/pages/profile/personal_information_page.dart';
import '../../presentation/pages/profile/my_applications_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/jobs/job_alerts_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String jobs = '/main/jobs';
  static const String savedJobs = '/main/saved';
  static const String cvs = '/main/cvs';
  static const String profile = '/main/profile';
  static const String jobDetails = '/jobs/:slug';
  static const String cvDetails = '/cvs/:id';
  static const String createCv = '/cvs/create';
  static const String editCv = '/cvs/edit';
  static const String companies = '/companies';
  static const String companyDetails = '/companies/:slug';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String personalInformation = '/profile/personal-information';
  static const String myApplications = '/profile/my-applications';
  static const String jobAlerts = '/job-alerts';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          final initialIndex = _getInitialTabIndex(tab);
          return MainPage(initialTab: initialIndex);
        },
      ),
      GoRoute(
        path: jobDetails,
        name: 'jobDetails',
        redirect: (context, state) {
          if (state.extra == null) {
            return jobs;
          }
          return null;
        },
        builder: (context, state) {
          final job = state.extra as JobEntity;
          return JobDetailsPage(job: job);
        },
      ),
      GoRoute(
        path: createCv,
        name: 'createCv',
        builder: (context, state) => const CreateCvPage(),
      ),
      GoRoute(
        path: editCv,
        name: 'editCv',
        redirect: (context, state) {
          if (state.extra == null) {
            return cvs;
          }
          return null;
        },
        builder: (context, state) {
          final cv = state.extra as CvEntity;
          return EditCvPage(cv: cv);
        },
      ),
      GoRoute(
        path: cvDetails,
        name: 'cvDetails',
        redirect: (context, state) {
          if (state.extra == null) {
            return cvs;
          }
          return null;
        },
        builder: (context, state) {
          final cv = state.extra as CvEntity;
          return CvDetailsPage(cv: cv);
        },
      ),
      GoRoute(
        path: companies,
        name: 'companies',
        builder: (context, state) => const CompaniesPage(),
      ),
      GoRoute(
        path: companyDetails,
        name: 'companyDetails',
        redirect: (context, state) {
          if (state.extra == null) {
            return companies;
          }
          return null;
        },
        builder: (context, state) {
          final company = state.extra as CompanyEntity;
          return CompanyDetailsPage(company: company);
        },
      ),
      GoRoute(
        path: editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: personalInformation,
        name: 'personalInformation',
        builder: (context, state) => const PersonalInformationPage(),
      ),
      GoRoute(
        path: myApplications,
        name: 'myApplications',
        builder: (context, state) => const MyApplicationsPage(),
      ),
      GoRoute(
        path: jobAlerts,
        name: 'jobAlerts',
        builder: (context, state) => const JobAlertsPage(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );

  static int _getInitialTabIndex(String? tab) {
    switch (tab) {
      case 'jobs':
        return 0;
      case 'saved':
        return 1;
      case 'cvs':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }
}
