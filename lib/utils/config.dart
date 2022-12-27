import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Config {
  FirebaseFirestore dbInstance = FirebaseFirestore.instance;
  FirebaseAuth authInstance = FirebaseAuth.instance;
  late UserCredential authResult;

  void login(String email, String password) async {
    authResult = await authInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  void register(String email, String password, String username, File profile,
      BuildContext ctx) async {
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
}
