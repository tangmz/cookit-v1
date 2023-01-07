// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cookit_mobile/utils/config.dart';
import 'package:flutter/material.dart';

import '../models/posts_model.dart';
import 'popular_grid.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});
  List<Post> get allPost => recipePosts;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            "Popular",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        StreamBuilder(
            stream: Config.dbInstance
                .collection('recipePosts')
                .withConverter(
                  fromFirestore: Post.fromFirestore,
                  toFirestore: (postItem, options) => postItem.toFirestore(),
                )
                .orderBy('favCount', descending: true)
                .orderBy('postRatings', descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) return SizedBox.shrink();
              return PopularGrid(
                  allPost: snapshot.data!.docs.map((e) => e.data()).toList());
            }),
      ],
    );
  }
}
