import 'package:flutter/material.dart';

/// Centralized loading overlay utility for consistent loading indicators
class LoadingOverlay {
  static OverlayEntry? _currentOverlay;

  /// Show a full-screen loading overlay
  static void show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    hide(); // Remove any existing overlay

    _currentOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier
          ModalBarrier(
            dismissible: barrierDismissible,
            color: Colors.black54,
          ),
          // Loading indicator
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  /// Hide the current loading overlay
  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  /// Show loading in a dialog
  static Future<T?> showDialog<T>({
    required BuildContext context,
    required Future<T> Function() task,
    String? message,
  }) async {
    show(context, message: message);
    try {
      final result = await task();
      hide();
      return result;
    } catch (e) {
      hide();
      rethrow;
    }
  }
}
