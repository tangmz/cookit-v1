// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_mobile/screens/bottom_navigation_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class Config {
  static FirebaseFirestore dbInstance = FirebaseFirestore.instance;
  static FirebaseAuth authInstance = FirebaseAuth.instance;
  static FirebaseStorage cloudInstance = FirebaseStorage.instance;
  static late UserCredential authResult;

  static void login(String email, String password, BuildContext ctx) async {
    try {
      authResult = await authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  static void register(String email, String password, String confirmPassword,
      String username, File? profile, BuildContext ctx) async {
    if (profile == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Please Provide a Profile Picture!'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Password Entered are Different!'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }

    try {
      authResult = await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      final ref = cloudInstance
          .ref()
          .child('userPhoto')
          .child('${authResult.user!.uid}.jpg');

      await ref.putFile(profile);

      final profileURL = await ref.getDownloadURL();

      authInstance.currentUser!.updatePhotoURL(profileURL);
      authInstance.currentUser!.updateDisplayName(username);

      await dbInstance
          .collection('users')
          .withConverter(
            fromFirestore: Users.fromFirestore,
            toFirestore: (Users userItem, options) => userItem.toFirestore(),
          )
          .doc(authResult.user!.uid)
          .set(Users(userName: username, email: email, profileSrc: profileURL));

      // favController.publishedNumStream = dbInstance
      //     .collection('users')
      //     .withConverter(
      //       fromFirestore: Users.fromFirestore,
      //       toFirestore: (userItem, options) => userItem.toFirestore(),
      //     )
      //     .doc(authResult.user!.uid)
      //     .snapshots()
      //     .asyncMap((event) => event.data()!.favPostsID);
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
      try {
        await authInstance
            .sendPasswordResetEmail(email: email.trim())
            .then((_) {
          return ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Password Reset Email Has Been Sent!'),
              backgroundColor: Colors.green[700],
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Please Enter an Email Address!'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  static void addToFav(String postID) {
    dbInstance
        .collection('users')
        .doc(Config.authInstance.currentUser!.uid)
        .update({
      'favPostsID': FieldValue.arrayUnion([postID])
    });
    dbInstance
        .collection('recipePosts')
        .doc(postID)
        .update({'favCount': FieldValue.increment(1)});
  }

  static void removeFromFav(String postID) {
    dbInstance
        .collection('users')
        .doc(Config.authInstance.currentUser!.uid)
        .update({
      'favPostsID': FieldValue.arrayRemove([postID])
    });
    dbInstance
        .collection('recipePosts')
        .doc(postID)
        .update({'favCount': FieldValue.increment(-1)});
  }
}

class favController extends GetxController {
  final favIDList = [''].obs;
  final publishedNum = 0.obs;
}

class ScrollGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
