// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import './post_tile.dart';
import '../screens/recipe_view_page.dart';
import '../models/posts_model.dart';

class PostGrid extends StatefulWidget {
  List<Post>? allPost;
  PostGrid({required this.allPost, super.key});
  // List<Post> get allPost => recipePosts;

  @override
  State<PostGrid> createState() => _PostGridState();
}

class _PostGridState extends State<PostGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: MasonryGridView.count(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        itemCount: widget.allPost != null ? widget.allPost!.length : 0,
        itemBuilder: (context, index) {
          return OpenContainer(
            closedBuilder: (context, VoidCallback _) => (PostTile(
              currentPost: widget.allPost![index],
            )),
            openBuilder: (context, VoidCallback _) =>
                RecipeViewPage(selectedPost: widget.allPost![index]),
          );
        },
      ),
    );
  }
}
