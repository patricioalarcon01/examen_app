import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Color? bg,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final color = Theme.of(context).colorScheme.primary;
    show(context, message, bg: color.withValues(alpha: 0.9));
  }

  static void showError(BuildContext context, String message) {
    show(context, message, bg: Colors.red.withValues(alpha: 0.9));
  }
}
