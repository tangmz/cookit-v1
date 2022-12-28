import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Config {
  static FirebaseFirestore dbInstance = FirebaseFirestore.instance;
  static FirebaseAuth authInstance = FirebaseAuth.instance;
  static late UserCredential authResult;

  static void login(String email, String password) async {
    authResult = await authInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static void register(String email, String password, String username,
      File? profile, BuildContext ctx) async {
    if (profile == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Please Provide a Profile Picture!'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }
    try {
      authResult = await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      final ref = FirebaseStorage.instance
          .ref()
          .child('userPhoto')
          .child('${authResult.user!.uid}.jpg');

      await ref.putFile(profile);

      final profileURL = await ref.getDownloadURL();

      authInstance.currentUser!.updatePhotoURL(profileURL);

      await dbInstance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({'username': username, 'email': email, 'password': password});
    } on PlatformException catch (error) {
      if (error.message != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(error.message.toString()),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
      }
    }
  }

  static void forgotPassword(String email, BuildContext ctx) async {
    if (email.trim() != '') {
      authInstance.sendPasswordResetEmail(email: email.trim()).then((_) {
        return ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Password Reset Email Has Been Sent!'),
            backgroundColor: Colors.green[700],
          ),
        );
      }).onError((error, stackTrace) {
        return ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('An Error Has Occurred!'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Please Enter an Email Address!'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }
}
