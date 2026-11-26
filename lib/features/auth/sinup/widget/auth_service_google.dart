import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceGoogle {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Random _random = Random();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // The user cancelled the Google account picker.
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-google-id-token',
          message: 'Google did not return an ID token.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'google-user-null',
          message: 'Firebase did not return a signed-in user.',
        );
      }

      // Use the Firebase UID as the document ID and wait for the write.
      final userRef = _firestore.collection('user').doc(user.uid);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        String id = '';
        for (int i = 0; i < 8; i++) {
          id += _random.nextInt(10).toString();
        }

        await userRef.set({
          'name': user.displayName,
          'email': user.email,
          'gender': 'male',
          'bio': 'Hi,I Use Hayaa',
          'photo': user.photoURL,
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

      return userCredential;
    } catch (error, stackTrace) {
      print('Google sign-in failed: $error');
      print(stackTrace);
      rethrow;
    }
  }
}
