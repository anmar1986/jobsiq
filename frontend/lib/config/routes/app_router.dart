import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/main/main_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/splash/splash_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String jobs = '/main/jobs';
  static const String savedJobs = '/main/saved';
  static const String cvs = '/main/cvs';
  static const String profile = '/main/profile';
  static const String jobDetails = '/jobs/:slug';
  static const String cvDetails = '/cvs/:id';
  static const String editProfile = '/profile/edit';

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
        path: main,
        name: 'main',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          final initialIndex = _getInitialTabIndex(tab);
          return MainPage(initialTab: initialIndex);
        },
      ),
      // TODO: Add more routes for job details, cv details, etc.
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
