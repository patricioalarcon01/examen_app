import 'package:flutter/material.dart';

class AppLoader {
  AppLoader._();

  static Future<void> show(BuildContext context,
      {String message = 'Cargando...'}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => Center(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3)),
                const SizedBox(width: 16),
                Flexible(
                    child: Text(message,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }
}
