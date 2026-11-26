import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Domain used for the internal, unique e-mail given to every guest account.
const String _guestEmailDomain = 'guest.hayaa.app';

/// Makes sure the device has a signed-in Firebase user with a profile
/// document in `user/{uid}`, creating both on first launch.
///
/// Existing users (Google / e-mail accounts signed in before the login screens
/// were removed) are left untouched.
///
/// Many screens look the current user up with `where('email', ...)`. An
/// anonymous user has no e-mail, so every guest would match each other. To avoid
/// that, a unique internal e-mail (`<uid>@guest.hayaa.app`) is linked to the
/// anonymous account. The random password is never stored or shown: the
/// session lives on the device. Uninstalling the app or clearing its data
/// loses the guest account.
///
/// Requires the Anonymous and Email/Password providers to be enabled in
/// Firebase Authentication. Throws on failure so the caller can show a retry.
Future<User> ensureGuestSession() async {
  final auth = FirebaseAuth.instance;

  User? user = auth.currentUser;
  user ??= (await auth.signInAnonymously()).user;
  if (user == null) {
    throw FirebaseAuthException(
      code: 'guest-user-null',
      message: 'Firebase did not return a user.',
    );
  }

  if (user.email == null || user.email!.isEmpty) {
    final email = '${user.uid}@$_guestEmailDomain';
    try {
      final linked = await user.linkWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: _randomPassword(),
        ),
      );
      user = linked.user ?? auth.currentUser ?? user;
    } on FirebaseAuthException catch (error) {
      // Typical cause: Email/Password provider disabled in Firebase.
      debugPrint('Guest e-mail link failed: ${error.code}');
      throw FirebaseAuthException(
        code: error.code,
        message: 'Could not prepare the guest account (${error.code}). '
            'Enable the Email/Password provider in Firebase Authentication.',
      );
    }
  }

  await _ensureProfile(user);
  return user;
}

Future<void> _ensureProfile(User user) async {
  final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
  final snapshot = await userRef.get();
  if (snapshot.exists) return;

  final random = Random.secure();
  String id = '';
  for (int i = 0; i < 8; i++) {
    id += random.nextInt(10).toString();
  }

  await userRef.set({
    'name': 'Guest $id',
    'email': user.email ?? '${user.uid}@$_guestEmailDomain',
    'gender': 'male',
    'bio': 'Hi,I Use Hayaa',
    'photo': '',
    'seen': 'online',
    'devicetoken': '',
    'country': 'US',
    'lang': 'en',
    'coin': '250',
    'vip': '0',
    'level': '0',
    'level2': '0',
    'birthdate': '',
    'phonenumber': '',
    'type': 'normal',
    'doc': user.uid,
    'id': id,
    'exp': '0',
    'exp2': '0',
    'daimond': '0',
    'myagent': '',
    'mybubble': '',
    'mycar': '',
    'myframe': '',
    'myfamily': '',
  });
}

String _randomPassword() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();
  return List.generate(32, (_) => chars[random.nextInt(chars.length)]).join();
}
