// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../models/posts_model.dart';
import '../screens/recipe_view_page.dart';
import 'popular_tile.dart';

class PopularGrid extends StatefulWidget {
  List<Post>? allPost;
  PopularGrid({required this.allPost, super.key});

  @override
  State<PopularGrid> createState() => _PopularGridState();
}

class _PopularGridState extends State<PopularGrid> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.allPost!.length,
      itemBuilder: (context, index) {
        return OpenContainer(
          closedElevation: 0,
          closedColor: Colors.grey.shade50,
          closedBuilder: (context, VoidCallback openContainer) => (PopularTile(
            currentPost: widget.allPost![index],
            onClicked: openContainer,
          )),
          openBuilder: (context, VoidCallback _) =>
              RecipeViewPage(selectedPost: widget.allPost![index]),
        );
      },
    );
  }
}
