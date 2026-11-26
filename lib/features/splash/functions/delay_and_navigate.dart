import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/views/home_view.dart';

import '../../auth/guest/guest_auth.dart';

Future<void> delayAndNavigate(BuildContext context,
    {bool withDelay = true}) async {
  if (withDelay) {
    await Future.delayed(const Duration(seconds: 4));
  }
  if (!context.mounted) return;

  try {
    await ensureGuestSession();
  } catch (error) {
    debugPrint('Guest session failed: $error');
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعذر الدخول'),
        content: Text('$error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    return delayAndNavigate(context, withDelay: false);
  }

  if (!context.mounted) return;
  Navigator.pushReplacementNamed(context, HomeView.id);
}
