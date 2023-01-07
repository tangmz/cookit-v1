// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userName, email;
  String? profileSrc;
  List<String>? favPostsID;
  List<String>? ownPostsID;

  Users({
    required this.userName,
    required this.email,
    this.profileSrc = '',
    favPostsID,
    ownPostsID,
  })  : favPostsID = favPostsID ?? [],
        ownPostsID = ownPostsID ?? [];

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Users(
      userName: data?['userName'],
      email: data?['email'],
      profileSrc: data?['profileSrc'],
      favPostsID: data?['favPostsID'] is Iterable
          ? (data?['favPostsID'] as List).isNotEmpty
              ? (data?['favPostsID'] as List).map((e) => e.toString()).toList()
              : null
          : null,
      ownPostsID: data?['ownPostsID'] is Iterable
          ? (data?['ownPostsID'] as List).isNotEmpty
              ? (data?['ownPostsID'] as List).map((e) => e.toString()).toList()
              : null
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userName": userName,
      "email": email,
      if (profileSrc != null) "profileSrc": profileSrc,
      if (favPostsID != null) "favPostsID": favPostsID,
      if (ownPostsID != null) "ownPostsID": ownPostsID,
    };
  }
}
