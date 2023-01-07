// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/posts_model.dart';
import '../utils/config.dart';
import '../screens/bottom_navigation_tab.dart';
import '../widgets/post_grid.dart';

class ProfilePageFav extends StatefulWidget {
  const ProfilePageFav({super.key});

  @override
  State<ProfilePageFav> createState() => _ProfilePageFavState();
}

class _ProfilePageFavState extends State<ProfilePageFav> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (BottomNavigationTab
            .favIDListController.favIDList.value.isNotEmpty) {
          return StreamBuilder(
            stream: Config.dbInstance
                .collection('recipePosts')
                .withConverter(
                  fromFirestore: Post.fromFirestore,
                  toFirestore: (postItem, options) => postItem.toFirestore(),
                )
                .where('postID',
                    whereIn:
                        BottomNavigationTab.favIDListController.favIDList.value)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (BottomNavigationTab
                  .favIDListController.favIDList.isNotEmpty) {
                return PostGrid(
                    allPost: snapshot.data!.docs.map((e) => e.data()).toList());
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
