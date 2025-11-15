import 'package:flutter/material.dart';
import '../error/failures.dart';

/// Centralized error handling utility for displaying user-friendly error messages
class ErrorHandler {
  /// Display error message as a SnackBar
  static void showErrorSnackBar(
    BuildContext context,
    Failure failure, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getErrorMessage(failure)),
        backgroundColor: Colors.red.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  /// Display success message as a SnackBar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Display info message as a SnackBar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Display error in a dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    Failure failure, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    if (!context.mounted) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Text(title ?? 'Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getErrorMessage(failure)),
            if (failure is ValidationFailure && failure.errors != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Please fix the following errors:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._buildValidationErrors(failure.errors!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Get user-friendly error message from Failure
  static String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    } else if (failure is AuthenticationFailure) {
      return failure.message.isEmpty
          ? 'Authentication failed. Please login again.'
          : failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message.isEmpty
          ? 'Please check your input and try again.'
          : failure.message;
    } else if (failure is NotFoundFailure) {
      return failure.message.isEmpty
          ? 'The requested resource was not found.'
          : failure.message;
    } else if (failure is ServerFailure) {
      return failure.message.isEmpty
          ? 'Server error occurred. Please try again later.'
          : failure.message;
    } else if (failure is CacheFailure) {
      return 'Local data error. Please try again.';
    } else {
      return failure.message.isEmpty
          ? 'An unexpected error occurred. Please try again.'
          : failure.message;
    }
  }

  /// Build validation error widgets
  static List<Widget> _buildValidationErrors(Map<String, List<String>> errors) {
    final widgets = <Widget>[];
    errors.forEach((field, messages) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: Colors.red)),
              Expanded(
                child: Text(
                  '${_formatFieldName(field)}: ${messages.join(', ')}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    });
    return widgets;
  }

  /// Format field name from snake_case to Title Case
  static String _formatFieldName(String field) {
    return field
        .split('_')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  /// Get validation error for a specific field
  static String? getFieldError(
    Failure? failure,
    String fieldName,
  ) {
    if (failure is ValidationFailure && failure.errors != null) {
      final errors = failure.errors![fieldName];
      if (errors != null && errors.isNotEmpty) {
        return errors.first;
      }
    }
    return null;
  }

  /// Check if failure is a network error
  static bool isNetworkError(Failure failure) {
    return failure is NetworkFailure;
  }

  /// Check if failure is an authentication error
  static bool isAuthError(Failure failure) {
    return failure is AuthenticationFailure || failure is UnauthorizedFailure;
  }
}
