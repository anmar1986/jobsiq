import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobsiq_mobile/core/error/failures.dart';
import 'package:jobsiq_mobile/core/utils/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    testWidgets('showErrorSnackBar displays error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorHandler.showErrorSnackBar(
                      context,
                      const ServerFailure('Test error'),
                    );
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the error
      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Verify the error message is displayed
      expect(find.text('Test error'), findsOneWidget);
    });

    testWidgets('showSuccessSnackBar displays success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorHandler.showSuccessSnackBar(
                      context,
                      'Operation successful',
                    );
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text('Operation successful'), findsOneWidget);
    });

    testWidgets('showErrorDialog displays error dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorHandler.showErrorDialog(
                      context,
                      const ServerFailure('Server error occurred'),
                      title: 'Error Title',
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Error Title'), findsOneWidget);
      expect(find.text('Server error occurred'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('showErrorDialog with validation errors',
        (WidgetTester tester) async {
      const validationFailure = ValidationFailure(
        'Validation failed',
        errors: {
          'email': ['Email is required', 'Email format is invalid'],
          'password': ['Password is too short'],
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorHandler.showErrorDialog(
                      context,
                      validationFailure,
                    );
                  },
                  child: const Text('Show Validation'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Validation'));
      await tester.pumpAndSettle();

      expect(find.text('Validation failed'), findsOneWidget);
      expect(find.textContaining('Email:'), findsOneWidget);
      expect(find.textContaining('Password:'), findsOneWidget);
    });

    test('getFieldError returns error for specific field', () {
      const validationFailure = ValidationFailure(
        'Validation failed',
        errors: {
          'email': ['Email is required'],
          'password': ['Password is too short'],
        },
      );

      final emailError = ErrorHandler.getFieldError(validationFailure, 'email');
      expect(emailError, 'Email is required');

      final passwordError =
          ErrorHandler.getFieldError(validationFailure, 'password');
      expect(passwordError, 'Password is too short');

      final nonExistentError =
          ErrorHandler.getFieldError(validationFailure, 'username');
      expect(nonExistentError, null);
    });

    test('isNetworkError returns true for NetworkFailure', () {
      expect(ErrorHandler.isNetworkError(const NetworkFailure('No connection')),
          true);
      expect(ErrorHandler.isNetworkError(const ServerFailure('Server error')),
          false);
    });

    test('isAuthError returns true for AuthenticationFailure', () {
      expect(
          ErrorHandler.isAuthError(const AuthenticationFailure('Auth failed')),
          true);
      expect(
          ErrorHandler.isAuthError(const UnauthorizedFailure('Unauthorized')),
          true);
      expect(
          ErrorHandler.isAuthError(const ServerFailure('Server error')), false);
    });
  });
}
