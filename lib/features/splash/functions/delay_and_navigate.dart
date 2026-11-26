import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/views/home_view.dart';

import '../../auth/choice between registration and login/views/choice_between_registration_and_login_view.dart';

Future<void> delayAndNavigate(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 4));
  if (!context.mounted) return;

  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  if (user != null) {
    try {
      final profile = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (!profile.exists) {
        await auth.signOut();
      }
    } catch (error) {
      debugPrint('Could not verify the signed-in user profile: $error');
    }
  }

  if (!context.mounted) return;

  if (auth.currentUser != null) {
    Navigator.pushReplacementNamed(context, HomeView.id);
  } else {
    Navigator.pushReplacementNamed(
      context,
      ChoiceBetweenRegistrationAndLogin.id,
    );
  }
}
