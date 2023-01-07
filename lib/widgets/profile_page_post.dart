// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';

import '../models/posts_model.dart';
import '../utils/config.dart';
import 'post_grid.dart';

class ProfilePagePost extends StatelessWidget {
  const ProfilePagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Config.dbInstance
          .collection('recipePosts')
          .withConverter(
            fromFirestore: Post.fromFirestore,
            toFirestore: (postItem, options) => postItem.toFirestore(),
          )
          .where('userID', isEqualTo: Config.authInstance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return PostGrid(
          allPost: snapshot.data!.docs.map((e) => e.data()).toList(),
        );
      },
    );
  }
}
