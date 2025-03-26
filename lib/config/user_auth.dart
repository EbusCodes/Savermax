import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection('Users');
  bool? _loading;
  bool? get loading => _loading;
  bool _error = false;
  bool get error => _error;
  bool _error1 = false;
  bool get error1 => _error1;

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      CollectionReference fcmtokenRef =
          FirebaseFirestore.instance.collection('FCMTokens');

      final token = await FirebaseMessaging.instance.getToken();
      final value = await profileRef
          .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      final tokenValue =
          await fcmtokenRef.where('FCMToken', isEqualTo: token).get();

      if (value.docs.isEmpty) {
        final refCode = Random().nextInt(1000000000).toString();
        FirebaseFirestore.instance
            .collection('Users')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .set({
          'UserID': FirebaseAuth.instance.currentUser?.uid,
          'Name': FirebaseAuth.instance.currentUser?.displayName,
          'Email': FirebaseAuth.instance.currentUser?.email,
          'Account Created': FieldValue.serverTimestamp(),
          'RefEarnings': 0,
          'Referrals': <String>[],
          'RefCode': refCode
        });

        FirebaseFirestore.instance
            .collection('FilePath')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .set({
          'UserID': FirebaseAuth.instance.currentUser?.uid,
          'Email': FirebaseAuth.instance.currentUser?.email,
          'Name': FirebaseAuth.instance.currentUser?.displayName,
          'Files': <String>[]
        });

        FirebaseAuth.instance.currentUser?.sendEmailVerification();
      }
      if (tokenValue.docs.isEmpty) {
        Random random = Random();
        int randomNumber = random.nextInt(1000000);
        FirebaseFirestore.instance
            .collection('FCMTokens')
            .doc('${FirebaseAuth.instance.currentUser!.email}$randomNumber')
            .set({
          "UserID": FirebaseAuth.instance.currentUser?.uid,
          "Name": FirebaseAuth.instance.currentUser?.displayName,
          "Email": FirebaseAuth.instance.currentUser?.email,
          "FCMToken": token,
          'Signed in': FieldValue.serverTimestamp()
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-disabled') {
        _error1 = true;
        notifyListeners();
      }
    } catch (error) {
      _error = true;
      notifyListeners();
      SnackBar(content: Text(error.toString()));
    }
    notifyListeners();
    return user;
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    const SnackBar(content: Text('Logout successful!'));
    notifyListeners();
  }

  Future emailLogout() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
